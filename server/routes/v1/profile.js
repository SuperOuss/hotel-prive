import initModels from "../../models/init-models.js";
import Sequelize from 'sequelize';
import dotenv from 'dotenv';
import express from 'express';
import bcrypt from 'bcrypt';
import axios from "axios";

dotenv.config();

const sequelize = new Sequelize(process.env.DATABASE_URL, { dialect: 'mysql', logging: console.log });
const models = initModels(sequelize);
const router = express.Router();

router.get('/get-user', async (req, res) => {
  const { email } = req.query;  // Assumes email is passed as a query parameter
  console.log("profile endpoint hit")

  if (!email) {
      return res.status(400).json({ error: 'Email parameter is required' });
  }

  try {
      // Fetch the user from the database using the email
      const user = await models.user.findOne({
          where: { email: email },
          attributes: ['email', 'fav_locations', 'fav_hotels']  // Specify the attributes you want to retrieve
      });

      if (!user) {
          return res.status(404).json({ error: 'User not found' });
      }

      // Return the user data including email, fav_locations, and fav_hotels
      res.json({
          email: user.email,
          fav_locations: user.fav_locations,
          fav_hotels: user.fav_hotels
      });

  } catch (error) {
      console.error('Error fetching user:', error);
      res.status(500).json({ error: 'Error retrieving user data' });
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
  const { email, hotelIds, latLngList } = req.body;
  console.log(req.body);

  // Check if user already exists
  const userExists = await models.user.findOne({
    where: { email: email }
  });

  if (userExists) {
    return res.status(400).json({ error: 'User already exists' });
  }

  try {
    // Augment latLngList with city and countryCode
    const augmentedLatLngList = await Promise.all(latLngList.map(async (latLng) => {
      const { latitude, longitude } = latLng;
      const geoInfo = await reverseGeocode(latitude, longitude);
      return { ...latLng, ...geoInfo };
    }));

    // Create new user with only required data
    const newUser = await models.user.create({
      email: email,
      fav_locations: augmentedLatLngList,
      fav_hotels: hotelIds,
    });

    res.json({ success: true, userId: newUser.id }); // Send back the ID of the new user
  } catch (error) {
    console.error('Error saving user to database:', error);
    res.status(500).json({ error: 'Error saving user to database' });
  }
});

async function reverseGeocode(latitude, longitude) {
  try {
      const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}`;
      const response = await axios.get(url, {
          headers: {
              'User-Agent': 'Hotel Prive/1.0 (o.tali@nuitee.com)' // Adapt with your app's real information
          }
      });

      const address = response.data.address;
      const countryCode = address.country_code;
      const city = address.city;
      return { countryCode, city };
  } catch (error) {
      console.error('Reverse geocode failed:', error);
      return null;
  }
}

export default router;


