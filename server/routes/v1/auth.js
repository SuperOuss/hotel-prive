import express from 'express';
import passport from 'passport';
import { Strategy as LocalStrategy } from 'passport-local';
import bcrypt from 'bcrypt';
import initModels from "../../models/init-models.js";
import Sequelize from 'sequelize';
import dotenv from 'dotenv';

dotenv.config();

const sequelize = new Sequelize(process.env.DATABASE_URL, { dialect: 'mysql', logging: console.log });
const models = initModels(sequelize);

const router = express.Router();

// Serialize user object to store in session
passport.serializeUser((user, done) => {
  done(null, { id: user.id, orgId: user.orgId });
});
/*
// Deserialize user object from session
passport.deserializeUser(async (id, done) => {
  try {
    const user = await models.user.findOne({ where: { id } });
    done(null, user);
  } catch (err) {
    done(err, null);
  }
});
*/
passport.deserializeUser(async (serializedData, done) => {
  try {
    const user = await models.user.findByPk(serializedData.id, {
      include: [{
        model: models.organisation,
        as: 'organisation',
        where: { id: serializedData.orgId },
        attributes: ['name']
      }]
    });
    done(null, user);
  } catch (error) {
    done(error);
  }
});

// Define passport strategy
passport.use(new LocalStrategy(
  async (login, password, done) => {
    try {
      const user = await models.user.findOne({ where: { email } });

      if (!user) {
        console.log('User not found');
        return done(null, false, { message: 'User not found' });
      }

      if (user.password && (await bcrypt.compare(password, user.password))) {
        console.log('User authenticated');
        return done(null, user);
      }

      if (legacyPasswordMatches(password, user.password)) {
        console.log('User authenticated with legacy password');
        return done(null, user);
      }

      console.log('Invalid password');
      return done(null, false, { message: 'Invalid password' });
    } catch (error) {
      console.error('Error during authentication:', error);
      return done(error);
    }
  }
));

// Custom function to handle legacy password comparison
function legacyPasswordMatches(inputPassword, storedPassword) {
  const matches = inputPassword === storedPassword;
  console.log(`Legacy password ${matches ? 'matches' : 'does not match'}`);
  return matches;
}

//endpoint for client to check if user is authenticated
router.get('/check-authentication', (req, res) => {
  if (req.isAuthenticated()) {
    // Return both authentication status and user details
    res.send({ 
      authenticated: true, 
      userId: req.user.id,
      userType: req.user.type,
      login: req.user.email,  
      first_name: req.user.first_name, 
      last_name: req.user.last_name,   
      company: req.user.company,
      region: req.user.region, 
      orgId: req.user.orgId,        
    });
    console.log("Auth checked");
  } else {
    res.send({ authenticated: false });
  }
});


router.post('/login', function(req, res, next) {
  passport.authenticate('local', function(err, user, info) {
    if (err) { 
      return next(err); 
    }
    if (!user) { 
      return res.status(401).json({ message: 'Mauvais login/mot de passe - Merci de contacter votre administrateur si vous avez oublié votre mot de passe' }); 
    }
    req.logIn(user, function(err) {
      if (err) { 
        return next(err); 
      }
      console.log('Session after login:', JSON.stringify(req.session, null, 2));
      return res.status(200).json({ message: 'login ok' });
    });
  })(req, res, next);
});

// Handle authentication failure
router.use('/login', function (req, res) {
  res.status(401).json({ message: 'Authentication failed' });
});

router.post('/logout', (req, res) => {
  req.logout(() => {
    req.session.destroy((err) => {
      if (err) {
        return res.status(500).json({ message: 'Error while logging out.' });
      }
      res.clearCookie('connect.sid', { path: '/' });
      res.status(200).json({ message: 'You have been successfully logged out.' });
    });
  });
});



export default router;
