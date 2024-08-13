import initModels from "../../models/init-models.js";
import Sequelize from 'sequelize';
import dotenv from 'dotenv';
import express from 'express';
import bcrypt from 'bcrypt';

dotenv.config();

const sequelize = new Sequelize(process.env.DATABASE_URL, { dialect: 'mysql', logging: console.log });
const models = initModels(sequelize);
const router = express.Router();

router.get('/profile', async (req, res) => {
  // Check if the user is authenticated (logged in)
  if (!req.isAuthenticated()) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  try {
    // Get the user ID from the session (assuming it is stored in req.user.id after login)
    const userId = req.user.id;

    // Fetch user data from the 'user' table based on the user ID
    const user = await models.user.findOne({ where: { id: userId } });

    // If the user doesn't exist, return an error
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // If the user exists, return the user data as JSON
    res.status(200).json(user);
  } catch (error) {
    // Handle any errors that occur during the process
    console.error('Error fetching user data:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

router.put('/update-password', async (req, res) => {
  const { userId, newPassword } = req.body;

  // Check if user ID is provided
  if (!userId || !newPassword) {
    return res.status(400).json({ error: 'User ID and new password are required' });
  }

  // Find user by ID
  const user = await models.user.findOne({
    where: {
      id: userId
    }
  });

  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }

  // Hash new password
  const saltRounds = 10;
  const hashedPassword = await bcrypt.hash(newPassword, saltRounds);

  try {
    // Update user password in the database
    await user.update({ password: hashedPassword });
    res.json({ success: true, message: 'Password updated successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error updating password in database' });
  }
});

router.post('/create-user', async (req, res) => {
  const { email, password, countryCode, phone, first_name, last_name,  } = req.body;
  // Check if user already exists
  const userExists = await models.user.findOne({
    where: {
      email: email
    }
  });
  if (userExists) {
    return res.status(400).json({ error: 'User already exists' });
  }
  // Hash user password
  const saltRounds = 10;
  const hashedPassword = await bcrypt.hash(password, saltRounds);
  try {
    const newUser = await models.user.create({
      first_name,
      last_name,
      email,
      countryCode,
      phone,
      password: hashedPassword,
    });
    res.json({ success: true, userId: newUser.id }); // Send back the ID of the new user
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error saving user to database' });
  }
});

//get all users from an org
router.get('/users', async (req, res) => {

  try {
    const users = await models.user.findAll({
      where: { orgId: orgId,
        type: 'agentTerrain',
        isDeactivated: false
       }, //Filter by orgId
      attributes: ['id', 'first_name', 'last_name', 'type', 'orgId'],
      include: [{
        model: models.organisation,
        as: 'organisation',
        attributes: ['name'],
      }],
    });
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});


export default router;


