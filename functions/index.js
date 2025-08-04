const functions = require("firebase-functions");
const {setGlobalOptions} = require("firebase-functions");
const axios = require("axios");
require("dotenv").config();

setGlobalOptions({maxInstances: 20});

const apiKey = process.env.GOOGLE_API_KEY;

exports.fetchNearbyLandmarks = functions.https.onRequest(async (req, res) => {
  const {
    latitude,
    longitude,
    radius = 5000,
    maxResultCount = 8,
    includedTypes = ["tourist_attraction"],
  } = req.body;

  const url = "https://places.googleapis.com/v1/places:searchNearby";

  try {
    const response = await axios.post(
        url,
        {
          locationRestriction: {
            circle: {
              center: {latitude, longitude},
              radius,
            },
          },
          includedTypes,
          maxResultCount,
        },
        {
          headers: {
            "Content-Type": "application/json",
            "X-Goog-Api-Key": apiKey,
            "X-Goog-FieldMask": "places.displayName,places.location," +
            "places.photos,places.id",
          },
        },
    );

    res.status(200).send(response.data);
  } catch (error) {
    const errorMessage = error.response?.data || error.message;
    console.error("Error from Google Places API:", errorMessage);
    res.status(500).send({error: "Failed to fetch landmarks"});
  }
});

exports.getPhotoUrl = functions.https.onRequest((req, res) => {
  const photoRef = req.body.photoReference;

  if (!photoRef) {
    return res.status(400).json({error: "Missing photoReference"});
  }

  const photoUrl = `https://places.googleapis.com/v1/${photoRef}/media?maxHeightPx=400&key=${apiKey}`;

  res.status(200).json({url: photoUrl});
});

exports.fetchRouteToLandmark = functions.https.onRequest(async (req, res) => {
  const origin = req.body.origin;

  const destination = req.body.destination;

  if (!origin || !destination) {
    return res.status(400).json({error: "Missing origin or destination"});
  }
  const url = `https://maps.googleapis.com/maps/api/directions/json?origin=${origin}&` +
    `destination=${destination}&mode=walking&key=${apiKey}`;

  try {
    const response = await axios.get(
        url,
        {
          headers: {
            "Content-Type": "application/json",
          },
        },
    );

    res.status(200).send(response.data);
  } catch (error) {
    const errorMessage = error.response?.data || error.message;
    console.error("Error from Google Rotue directions API:", errorMessage);
    res.status(500).send({error: "Failed to fetch route directions"});
  }
});

exports.fetchDistanceToLandmark = functions.https.onRequest(
    async (req, res) => {
      const currentLatitude = req.body.currentLatitude;

      const currentLongitude = req.body.currentLongitude;

      const destinationLatitude = req.body.destinationLatitude;

      const destinationLongitude = req.body.destinationLongitude;

      const mode = req.body.mode;

      if (isNaN(currentLatitude) || isNaN(currentLongitude) ||
      isNaN(destinationLatitude) ||
      isNaN(destinationLongitude) || !mode) {
        return res.status(400).json({error: "Missing Input Parameters"});
      }
      const url = `https://maps.googleapis.com/maps/api/distancematrix/json` +
      `?origins=${currentLatitude},${currentLongitude}` +
      `&destinations=${destinationLatitude},${destinationLongitude}` +
      `&mode=${mode}` +
      `&key=${apiKey}`;

      try {
        const response = await axios.get(
            url,
            {
              headers: {
                "Content-Type": "application/json",
              },
            },
        );

        res.status(200).send(response.data);
      } catch (error) {
        const errorMessage = error.response?.data || error.message;
        console.error("Error from Google Direction Matrix API:", errorMessage);
        res.status(500).send({error: "Failed to fetch direction Matrix"});
      }
    });
