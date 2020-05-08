// node back-end server
const express = require('express');
const app = express();
const total_literature = require('./api/total_literature');

// back-end api router
app.use('/api/covid-19', total_literature);

// listening port
app.listen(3000);
console.log('success listen at port: 3000......');