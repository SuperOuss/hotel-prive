import initModels from "../../models/init-models.js";
import Sequelize from 'sequelize';
import dotenv from 'dotenv';
import express from 'express';
import liteApi from 'liteapi-node-sdk';

dotenv.config();

const sequelize = new Sequelize(process.env.DATABASE_URL, { dialect: 'mysql', logging: console.log });
const models = initModels(sequelize);

const router = express.Router();
const openAIkey = process.env.OPENAI_KEY;

//const prod_apiKey = process.env.PROD_API_KEY;
const apiKey = process.env.SAND_API_KEY;

const sdk = liteApi(apiKey);

router.post('/prebook', async (req, res) => {
    const { offerId } = req.body;
  
    try {
      // Call the prebook method from liteApi SDK
      const prebookResponse = await sdk.preBook({ offerId, "usePaymentSdk": true });
  
      // Send the response back to the client
      res.json(prebookResponse);
    } catch (error) {
      console.error("Error during prebooking:", error);
      res.status(500).json({ error: "Failed to prebook offer" });
    }
  });

export default router;

