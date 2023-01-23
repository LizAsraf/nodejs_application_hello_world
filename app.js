'use strict';

const express = require('express');

// Constants
const PORT = process.env.PORT || 8885;

// App
const app = express();
app.get('/', (req, res) => {
  res.send('Hello World');
});

app.listen(PORT, () => {
  console.log(`Running on http://0.0.0.0:${PORT}`);
});