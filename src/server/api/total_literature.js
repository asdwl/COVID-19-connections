const models = require('../db');
const express = require('express');
const router = express.Router();
const mysql = require('mysql');
// connect database
let conn = mysql.createConnection(models.mysql);
conn.connect();
// add total_literature api
router.get('/total_literature', (req, res) => {
  let sql = "SELECT * FROM `covid-19`.`total_literature`";
  conn.query(sql, (err, result) => {
    if (err) {
      console.log("sql query error: " + err);
    }
    if (result) {
      console.log("sql query successed!");
      res.json(result);
    }
  })
});
module.exports = router;
