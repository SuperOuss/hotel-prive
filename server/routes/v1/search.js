import initModels from "../../models/init-models.js";
import Sequelize from 'sequelize';
import dotenv from 'dotenv';
import express from 'express';
import liteApi from 'liteapi-node-sdk';
import axios from 'axios';
import hotel from "../../models/hotel.js";
import crypto from 'crypto';

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

router.get('/hotels', async (req, res) => {
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

    const hotels = await models.hotel.findAll({
      where: whereClause
    });

    res.json(hotels);
  } catch (error) {
    console.error('Search error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

router.get('/get-deals', async (req, res) => {
  console.log("deal count endpoint hit")
  const { lat, lon, countryCode, city } = req.query; // Extract lat and lon directly from query parameters
  console.log(req.query);

  // Check if latitude and longitude are provided
  if (!lat || !lon) {
    return res.status(400).json({ error: 'Latitude and longitude parameters are required' });
  }

  try {

    // Validate that latitude and longitude are numbers
    if (isNaN(lat) || isNaN(lon)) {
      return res.status(400).json({ error: 'Invalid latitude or longitude' });
    }

    const { results, dealCount } = await getAndCountDeals(lat, lon, countryCode, city);

    // Return the results and the deal count
    res.json({
      message: "Deals successfully retrieved",
      dealCount: dealCount,
      results: results
    });

  } catch (error) {
    console.error("Error in get-deals endpoint:", error);
    res.status(500).json({ error: 'Error retrieving deals' });
  }
});

router.post('/get-hotel-rates', async (req, res) => {
  const rawHotelIds = req.body.hotelIds;

  const HotelIds = rawHotelIds.map(id => formatHotelId(id));
  console.log(HotelIds);

  // Fetch rates for all provided hotel IDs in one go
  const ratesData = await fetchRates(HotelIds);
  const hotelData = await fetchhotelDetails(HotelIds);

  const hotelDetailsMap = new Map(hotelData.map(item => [item.hotelId, item]));

  // Merge rates data with hotel details using the map
  const mergedData = ratesData.map(rate => {
      const hotelDetails = hotelDetailsMap.get(rate.hotelId);
      return {
          hotelId: rate.hotelId,
          hotelName: hotelDetails ? hotelDetails.hotelName : "Hotel name not found",
          defaultImageUrl: hotelDetails ? hotelDetails.defaultImageUrl : "Default image not found",
          stars: hotelDetails ? hotelDetails.stars : "Stars not found",
          offerRetailRate: rate.offerRetailRate,
          suggestedSellingPrice: rate.suggestedSellingPrice,
          percentageDifference: rate.percentageDifference
      };
  });
  res.json(mergedData);

  if (ratesData.error) {
    return res.status(500).json({ error: ratesData.error });
  }// Directly return the data fetched from the API
});



const getAndCountDeals = async (lat, lon, countryCode, city) => {
  const results = [];
  let dealCount = 0;

  // Convert lat and lon from string to float
  const latitude = parseFloat(lat);
  const longitude = parseFloat(lon);

  try {
    const today = new Date();

    // Check-in date: One month from today
    const checkInDate = new Date(today);
    checkInDate.setMonth(today.getMonth() + 1);

    // Check-out date: Three days after check-in
    const checkOutDate = new Date(checkInDate);
    checkOutDate.setDate(checkInDate.getDate() + 3);

    // Format dates to YYYY-MM-DD (ISO 8601 format)
    const formattedCheckIn = checkInDate.toISOString().split('T')[0];
    const formattedCheckOut = checkOutDate.toISOString().split('T')[0];
    const response = await axios.post('https://api.liteapi.travel/v3.0/hotels/rates', {
      countryCode: countryCode,
      city: city,
      occupancies: [{ adults: 2 }],
      currency: "USD",
      guestNationality: "US",
      checkin: formattedCheckIn,
      checkout: formattedCheckOut,
      limit: 10,
      latitude: latitude,
      longitude: longitude,
      margin: 0
    }, {
      headers: {
        'X-API-Key': sandbox_apiKey,  // Ensure the API key is passed securely and not hard-coded
        'Accept': 'application/json',
        'Content-type': 'application/json'
      }
    });

    // Process response data
    if (response.data && response.data.data && response.data.data.length > 0) {
      response.data.data.forEach(hotel => {
        // Check the first room type if available
        if (hotel.roomTypes && hotel.roomTypes.length > 0) {
          const firstRoomType = hotel.roomTypes[0]; // Get only the first roomType
          const offerRetailRate = firstRoomType.offerRetailRate.amount;
          const suggestedSellingPrice = firstRoomType.suggestedSellingPrice.amount;

          // Log the rates for verification
          console.log(`Hotel ID: ${hotel.hotelId}, First RoomType Offer Retail Rate: ${offerRetailRate}, Suggested Selling Price: ${suggestedSellingPrice}`);

          // Check if the offerRetailRate is at least 10% lower than the suggestedSellingPrice
          const tenPercentLess = suggestedSellingPrice * 0.90;
          if (offerRetailRate <= tenPercentLess) {
            dealCount++; // Increment deal count if condition met
          } else {
            console.log(`No deal for Hotel ID: ${hotel.hotelId}`);
          }

          // Store result for this hotel
          results.push({
            hotelId: hotel.hotelId,
            offerRetailRate,
            suggestedSellingPrice,
            deal: offerRetailRate <= tenPercentLess
          });
        } else {
          console.log(`No room types available for hotel ID: ${hotel.hotelId}`);
          results.push({
            hotelId: hotel.hotelId,
            firstRoomType: null,
            deal: false
          });
        }
      });
    } else {
      console.log(`No hotel data available at latitude: ${latitude}, longitude: ${longitude}`);
      results.push({
        dataProcessed: 0,
        deal: false
      });
    }
  } catch (error) {
    console.error(`Error fetching deals for latitude: ${latitude}, longitude: ${longitude}: ${error}`);
    results.push({
      error: error.message,
      deal: false
    });
  }
  console.log(dealCount);
  return { results, dealCount };
};


async function fetchRates(hotelIds) {
  try {
    const today = new Date();

    // Check-in date: One month from today
    const checkInDate = new Date(today);
    checkInDate.setMonth(today.getMonth() + 1);

    // Check-out date: Three days after check-in
    const checkOutDate = new Date(checkInDate);
    checkOutDate.setDate(checkInDate.getDate() + 3);

    // Format dates to YYYY-MM-DD (ISO 8601 format)
    const formattedCheckIn = checkInDate.toISOString().split('T')[0];
    const formattedCheckOut = checkOutDate.toISOString().split('T')[0];

    const response = await axios.post('https://api.liteapi.travel/v3.0/hotels/rates', {
      hotelIds: hotelIds,  // Array of hotelIds
      occupancies: [{ adults: 2 }],
      currency: "USD",
      guestNationality: "US",
      checkin: formattedCheckIn,
      checkout: formattedCheckOut,
      margin: 0
    }, {
      headers: {
        'X-API-Key': sandbox_apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    });

    const ratesData = response.data.data;
    const allHotelsRates = ratesData.map(hotelData => {
      const hotelId = hotelData.hotelId;
      if (hotelData.roomTypes && hotelData.roomTypes.length > 0) {
        const firstRoomType = hotelData.roomTypes[0];
        const offerRetailRate = firstRoomType.offerRetailRate.amount;
        const suggestedSellingPrice = firstRoomType.suggestedSellingPrice.amount;
        // Calculate the percentage difference
        let percentageDifference = 0;
        if (suggestedSellingPrice > 0) { // Ensure no division by zero
          percentageDifference = ((suggestedSellingPrice - offerRetailRate) / suggestedSellingPrice) * 100;
        }
        return {
          hotelId: hotelId,
          offerRetailRate: offerRetailRate,
          suggestedSellingPrice: suggestedSellingPrice,
          percentageDifference: `${percentageDifference.toFixed(2)}%`

        };
      } else {
        return {
          hotelId: hotelId,
          hotelName: hotelInfo ? hotelInfo.name : "Hotel name not found",
          offerRetailRate: "No room type available",
          suggestedSellingPrice: "No room type available"
        };
      }
    });
    return allHotelsRates;
  } catch (error) {
    console.error(`Error fetching rates for hotel ${hotelIds}:`, error);
    return { error: error.message };  // Return error message in a structured form
  }
}



async function fetchhotelDetails(hotelIds) {
    const hotelDetails = [];

    // Loop through all hotel IDs and fetch their details
    for (let hotelId of hotelIds) {
        try {
            const url = `https://api.liteapi.travel/v3.0/data/hotel`;
            const response = await axios.get(url, {
                headers: {
                    'X-API-Key': sandbox_apiKey,
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                params: {
                    hotelId: hotelId  // Pass the current hotelId as a query parameter
                }
            });

            if (response.data && response.data.data) {
                const hotelData = response.data.data;
                console.log(hotelData.starRating);
                // Find the default image from the hotelImages array
                const defaultImage = hotelData.hotelImages.find(image => image.defaultImage) || {};

                // Construct hotel detail object
                hotelDetails.push({
                    hotelId: hotelId,
                    hotelName: hotelData.name || "Hotel name not found",
                    defaultImageUrl: defaultImage.url || "Default image not found",
                    stars: hotelData.starRating || "Stars not found"
                });
            }
        } catch (error) {
            console.error(`Error fetching details for hotel ${hotelId}:`, error);
            // Optionally push an error state for this hotel to the array
            hotelDetails.push({
                hotelId: hotelId,
                error: "Failed to fetch details"
            });
        }
    }

    return hotelDetails;
}

function formatHotelId(id) {
  if (!id.startsWith('lp')) {
      // Convert the numeric ID to hexadecimal
      let hex = id.toString(16);
      return `lp${hex}`;
  }
  return id;
}

export default router;
