const express = require('express');
const axios = require('axios');

// Create an Express application
const app = express();
const port = 3000;

// Define a route to fetch data from the backend
app.get('/', async (req, res) => {
  try {
    // Make a GET request to your backend API
    const backendResponse = await axios.get('http://backend.terasky-int.com');

    // Extract data from the backend response
    const responseData = backendResponse.data;

    // Send the data as a JSON response
    res.json(responseData);
  } catch (error) {
    // Handle errors, e.g., connection issues or errors from the backend
    console.error('Error fetching data from the backend:', error.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Frontend server listening at http://localhost:${port}`);
});