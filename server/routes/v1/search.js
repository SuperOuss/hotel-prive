import initModels from "../../models/init-models.js";
import Sequelize from 'sequelize';
import dotenv from 'dotenv';
import express from 'express';
import liteApi from 'liteapi-node-sdk';
import axios from 'axios';

dotenv.config();

const sequelize = new Sequelize(process.env.DATABASE_URL, { dialect: 'mysql', logging: console.log });
const models = initModels(sequelize);

const router = express.Router();


//const prod_apiKey = process.env.PROD_API_KEY;
const sandbox_apiKey = process.env.SAND_API_KEY;


router.get("/search-hotels-direct", async (req, res) => {
  const { countryCode, cityName, starRating, limit } = req.query;
  const url = `https://api.liteapi.travel/v3.0/data/hotels`;

  try {
    const response = await axios.get(url, {
      headers: {
        'accept': 'application/json',
        'X-Api-Key': sandbox_apiKey // Ensure you replace this with your actual API key
      },
      params: {
        ...req.query
      }
    });

    res.json(response.data);
  } catch (error) {
    console.error("Error fetching hotel data:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

router.get('/search-hotels', async (req, res) => {
  const { name, latitude, longitude, countryCode, city, starRating, rating, reviewCount } = req.query;
  try {
      const whereClause = {};

      if (name) {
          whereClause.name = { [Sequelize.Op.iLike]: `%${name}%` };
      }
      if (latitude && longitude) {
          whereClause.latitude = { [Sequelize.Op.eq]: parseFloat(latitude) };
          whereClause.longitude = { [Sequelize.Op.eq]: parseFloat(longitude) };
      }
      if (countryCode && city) {
          whereClause.countryCode = { [Sequelize.Op.eq]: countryCode };
          whereClause.city = { [Sequelize.Op.iLike]: `%${city}%` };
      }
      if (starRating) {
          whereClause.starRating = { [Sequelize.Op.eq]: parseFloat(starRating) };
      }
      if (rating) {
          whereClause.rating = { [Sequelize.Op.eq]: parseFloat(rating) };
      }
      if (reviewCount) {
          whereClause.reviewCount = { [Sequelize.Op.gte]: parseInt(reviewCount) };
      }

      const hotels = await Hotel.findAll({
          where: whereClause
      });

      res.json(hotels);
  } catch (error) {
      console.error('Search error:', error);
      res.status(500).json({ error: 'Internal server error' });
  }
});


export default router;
