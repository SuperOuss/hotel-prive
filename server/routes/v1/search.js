import initModels from "../../models/init-models.js";
import Sequelize from 'sequelize';
import dotenv from 'dotenv';
import express from 'express';
import liteApi from 'liteapi-node-sdk';
import axios from 'axios';
import hotel from "../../models/hotel.js";
import OpenAI from "openai";

dotenv.config();

const sequelize = new Sequelize(process.env.DATABASE_URL, { dialect: 'mysql', logging: console.log });
const models = initModels(sequelize);

const router = express.Router();
const openAIkey = process.env.OPENAI_KEY;
const openai = new  OpenAI({ apiKey: openAIkey });

//const prod_apiKey = process.env.PROD_API_KEY;
const sandbox_apiKey = process.env.PROD_API_KEY;


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

router.post('/get-rates', async (req, res) => {
  console.log("get hotel rates endpoint hit");
  console.log(req.body);

  // Flatten the nested array
  const rawHotelIds = req.body.hotelIds.flat();

  // Format the hotel IDs
  const hotelIds = rawHotelIds.map(id => formatHotelId(id));
  console.log(hotelIds);

  // Fetch rates for all provided hotel IDs in one go
  const ratesData = await fetchRates(hotelIds);
  const hotelData = await fetchhotelDetails(hotelIds);

  const hotelDetailsMap = new Map(hotelData.map(item => [item.hotelId, item]));

  // Merge rates data with hotel details using the map
  const mergedData = ratesData.map(rate => {
    const hotelDetails = hotelDetailsMap.get(rate.hotelId);
    return {
      hotelId: rate.hotelId,
      hotelName: hotelDetails ? hotelDetails.hotelName : "Hotel name not found",
      defaultImageUrl: hotelDetails ? hotelDetails.defaultImageUrl : "Default image not found",
      stars: hotelDetails ? hotelDetails.stars : "Stars not found",
      location: hotelDetails ? hotelDetails.location : "Location not found",
      offerRetailRate: Math.floor(rate.offerRetailRate),
      suggestedSellingPrice: Math.floor(rate.suggestedSellingPrice),
      percentageDifference: rate.percentageDifference
    };
  });
  res.json(mergedData);

  if (ratesData.error) {
    return res.status(500).json({ error: ratesData.error });
  }// Directly return the data fetched from the API
});

router.get('/get-hotel-details', async (req, res) => {
  console.log("get hotel details endpoint hit");
  const hotelId = req.query.hotelId; // Correct this line
  console.log(req.query);

  // Check if hotelId is provided
  if (!hotelId) {
    return res.status(400).json({ error: 'Hotel ID parameter is required' });
  }

  try {
    // Fetch hotel details using the provided hotelId
    const hotelDetails = await fetchSingleHotelDetail(hotelId);

    // Return the hotel details
    res.json(hotelDetails);
  } catch (error) {
    console.error("Error fetching hotel details:", error);
    res.status(500).json({ error: 'Error retrieving hotel details' });
  }
});

router.get('/reviews', async (req, res) => {
  console.log("Reviews endpoint hit");
  const hotelId = req.query.hotelId;

  // Check if hotelId is provided
  if (!hotelId) {
    return res.status(400).json({ error: 'Hotel ID parameter is required' });
  }

  try {
    // Fetch the reviews using the provided hotelId
    const reviews = await fetchReviews(hotelId);
    console.log(reviews);

    // Return the hotel details
    res.json(reviews);
  } catch (error) {
    console.error("Error fetching hotel details:", error);
    res.status(500).json({ error: 'Error retrieving hotel details' });
  }
});

router.post('/get-rate', async (req, res) => {
  console.log("get single hotel rates endpoint hit");
  console.log(req.body);

  const { firstDate, lastDate, hotelId } = req.body;

  const formattedCheckin = new Date(firstDate).toISOString().split('T')[0];
  const formattedCheckout = new Date(lastDate).toISOString().split('T')[0];
  console.log(formattedCheckin, formattedCheckout);

  try {
    // Fetch rates for the provided hotel ID
    const ratesData = await fetchRate(hotelId, formattedCheckin, formattedCheckout);
  
    // Access the first element of ratesData
    const firstRateData = ratesData[0];
  
    // Extract and organize the required data
    const roomTypeDetails = firstRateData.roomTypes.map(roomType => {
      const offerRetailRate = Math.round(roomType.offerRetailRate.amount);
      const suggestedSellingPrice = Math.round(roomType.suggestedSellingPrice.amount);
  
      // Calculate the percentage difference
      const percentageDifference = ((suggestedSellingPrice - offerRetailRate) / offerRetailRate) * 100;
  
      return {
        offerRetailRate: { ...roomType.offerRetailRate, amount: offerRetailRate },
        suggestedSellingPrice: { ...roomType.suggestedSellingPrice, amount: suggestedSellingPrice },
        offerId: roomType.offerId,
        mappedRoomId: roomType.rates[0].mappedRoomId,
        boardName: roomType.rates[0].boardName,
        name: roomType.rates[0].name,
        cancellationPolicy: roomType.rates[0].cancellationPolicies,
        percentageDifference: percentageDifference.toFixed(2) // Format to 2 decimal places
      };
    });

    // Return the organized data
    return res.json(roomTypeDetails);
  } catch (error) {
    return res.status(500).json({ error: "Failed to fetch rates" });
  }
});




//functions

async function fetchRate(hotelId, checkin, checkout) {
  console.log("Fetching rates for hotel:", hotelId, checkin, checkout);
  try {
    const response = await axios.post('https://api.liteapi.travel/v3.0/hotels/rates', {
      hotelIds: [hotelId],  // Single hotelId wrapped in an array
      occupancies: [{ adults: 2 }],
      currency: "USD",
      guestNationality: "US",
      checkin: checkin,
      checkout: checkout,
      margin: 0,
      roomMapping: true
    }, {
      headers: {
        'X-API-Key': sandbox_apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    });
    console.log(response.data);
    return response.data.data;  // Return the raw response data
  } catch (error) {
    console.error(`Error fetching rates for hotel ${hotelId}:`, error);
    return { error: "failed to fetch rates" };  // Return error message in a structured form
  }
}


const getAndCountDeals = async (lat, lon, countryCode, city) => {
  const latitude = parseFloat(lat);
  const longitude = parseFloat(lon);

  console.log(countryCode, city, latitude, longitude);

  try {
    const today = new Date();
    const checkInDate = new Date(today);
    checkInDate.setMonth(today.getMonth() + 1);
    const checkOutDate = new Date(checkInDate);
    checkOutDate.setDate(checkInDate.getDate() + 1);
    const formattedCheckIn = checkInDate.toISOString().split('T')[0];
    const formattedCheckOut = checkOutDate.toISOString().split('T')[0];

    const requestBody = {
      occupancies: [{ adults: 2 }],
      currency: "USD",
      guestNationality: "US",
      checkin: formattedCheckIn,
      checkout: formattedCheckOut,
      limit: 10,
      margin: -10
    };

    try {
      console.log("Fetching list of hotels by city/country code");
      const encodedCity = encodeURIComponent(city);
      const url = `https://api.liteapi.travel/v3.0/data/hotels?countryCode=${countryCode}&cityName=${encodedCity}&limit=10`;

      console.log("Request URL:", url);
      const hotelListResponse = await axios.get(`https://api.liteapi.travel/v3.0/data/hotels?countryCode=${countryCode}&cityName=${encodedCity}&limit=20&minRating=8`, {
        headers: {
          'X-API-Key': sandbox_apiKey,
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
      });
      console.log(hotelListResponse.data.data[0])
      const hotelIds = hotelListResponse.data.data.map(hotel => hotel.id);

      console.log("Fetching rates for hotels");
      const rateResponse = await axios.post('https://api.liteapi.travel/v3.0/hotels/rates', {
        ...requestBody,
        hotelIds: hotelIds
      }, {
        headers: {
          'X-API-Key': sandbox_apiKey,
          'Accept': 'application/json',
          'Content-type': 'application/json'
        }
      });

      return processResponseData(rateResponse);

    } catch (error) {
      console.error('Error with countryCode and city:', error);
      console.log("Retrying with latitude and longitude");

      const hotelListResponse = await axios.get(`https://api.liteapi.travel/v3.0/data/hotels?latitude=${latitude}&longitude=${longitude}&limit=10`, {
        headers: {
          'X-API-Key': sandbox_apiKey,
          'Accept': 'application/json'
        }
      });

      const hotelIds = hotelListResponse.data.map(hotel => hotel.id);

      const rateResponse = await axios.post('https://api.liteapi.travel/v3.0/hotels/rates', {
        ...requestBody,
        hotelIds: hotelIds
      }, {
        headers: {
          'X-API-Key': sandbox_apiKey,
          'Accept': 'application/json',
          'Content-type': 'application/json'
        }
      });

      return processResponseData(rateResponse);
    }

  } catch (error) {
    console.error(`Error fetching deals for latitude: ${latitude}, longitude: ${longitude}: ${error}`);
    return {
      results: [{ error: error.message, deal: false }],
      dealCount: 0
    };
  }
};

const processResponseData = (response) => {
  const results = [];
  let dealCount = 0;

  if (response.data && response.data.data && response.data.data.length > 0) {
    response.data.data.forEach(hotel => {
      if (hotel.roomTypes && hotel.roomTypes.length > 0) {
        const firstRoomType = hotel.roomTypes[0];
        const offerRetailRate = firstRoomType.offerRetailRate.amount;
        const suggestedSellingPrice = firstRoomType.suggestedSellingPrice.amount;

        console.log(`Hotel ID: ${hotel.hotelId}, First RoomType Offer Retail Rate: ${offerRetailRate}, Suggested Selling Price: ${suggestedSellingPrice}`);

        const tenPercentLess = suggestedSellingPrice * 0.80;
        if (offerRetailRate <= tenPercentLess) {
          dealCount++;
        } else {
          console.log(`No deal for Hotel ID: ${hotel.hotelId}`);
        }

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
    checkOutDate.setDate(checkInDate.getDate() + 1);

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
      margin: -10
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
    console.error(`Error fetching rates for hotel ${hotelIds}:`);
    return { error: "failed to fetch rates" };  // Return error message in a structured form
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
        console.log(hotelData.city);

        // Check if hotelImages is an array and find the default image
        let defaultImageUrl = hotelData.main_photo || "Default image not found";
        if (Array.isArray(hotelData.hotelImages)) {
          const defaultImage = hotelData.hotelImages.find(image => image.defaultImage) || {};
          defaultImageUrl = defaultImage.url || hotelData.main_photo || "Default image not found";
        }

        // Construct hotel detail object
        hotelDetails.push({
          hotelId: hotelId,
          hotelName: hotelData.name || "Hotel name not found",
          defaultImageUrl: defaultImageUrl,
          stars: hotelData.starRating || "Stars not found",
          location: hotelData.city
        });
      }
    } catch (error) {
      console.error(`Error fetching details for hotel ${hotelId}: ${error.message}`);
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
  try {
    // Ensure id is treated as a string
    const idStr = String(id);

    // Check if the id already starts with "lp"
    if (idStr.startsWith("lp")) {
      return idStr;
    }

    // Convert from string to uint
    const nuiteeHotelID = parseInt(idStr, 10);
    if (isNaN(nuiteeHotelID)) {
      throw new Error("Invalid input: not a number");
    }

    // Convert nuiteeHotelID to a hexadecimal string, ensuring it is in lower case
    const nuiteeHotelIDStr = nuiteeHotelID.toString(16).toLowerCase();

    // Add prefix and return
    return "lp" + nuiteeHotelIDStr;
  } catch (err) {
    console.error(err.message);
    return ""; // Return an empty string or handle the error as needed
  }
}

async function fetchSingleHotelDetail(hotelId) {
  try {
    const url = `https://api.liteapi.travel/v3.0/data/hotel`;
    const response = await axios.get(url, {
      headers: {
        'X-API-Key': sandbox_apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      params: {
        hotelId: hotelId  // Pass the hotelId as a query parameter
      }
    });

    if (response.data && response.data.data) {
      const hotelData = response.data.data;
      return hotelData;
    }
  } catch (error) {
    console.error(`Error fetching details for hotel ${hotelId}: ${error.message}`);
  }
}

async function fetchReviews(hotelId) {
  try {
    const url = `https://api.liteapi.travel/v3.0/data/reviews`;
    const response = await axios.get(url, {
      headers: {
        'X-API-Key': sandbox_apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      params: {
        hotelId: hotelId,
      }
    });

    if (response.data && response.data.data) {
      const reviews = response.data.data;
      const sentimentResult = await extractSentimentReviews(reviews); // Assuming extractSentimentReviews is async
      return {
        reviews: reviews,
        sentimentAnalysis: sentimentResult,
      };
    } else {
      return {
        reviews: [],
        totalReviews: 0,
        sentimentAnalysis: "No reviews available for analysis."
      };
    }
  } catch (error) {
    console.error(`Error fetching details for hotel ${hotelId}: ${error.message}`);
    return {
      reviews: [],
      totalReviews: 0,
      sentimentAnalysis: "Error in fetching reviews."
    };
  }
}

async function extractSentimentReviews(reviews) {
  try {
    const combinedReviewsPros = reviews.map(review => review.pros).join("\n");
    const combinedReviewsCons = reviews.map(review => review.cons).join("\n");

    const sentimentResponse = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [
        { role: "assistant", content: "You are a helpful assistant." },
        {
            role: "user",
            content: "Provide a sentiment analysis for the following hotel reviews (only return a conclusion and under 100 words):\n" + combinedReviewsPros + combinedReviewsCons
        },
    ],
    });
    console.log("Sentiment Analysis Result:", sentimentResponse.choices[0].message.content);
    return sentimentResponse.choices[0].message.content;
  } catch (error) {
    console.error(`Error extracting sentiment from reviews: ${error.message}`);
  }
}

export default router;
