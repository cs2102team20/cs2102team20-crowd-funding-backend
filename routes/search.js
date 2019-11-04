var express = require("express");
var router = express.Router();

const { Pool } = require("pg");
// const pool = new Pool({
//   user: 'postgres',
//   host: 'localhost',
//   database: 'postgres',
//   password: 'password',
//   port: 5432,
// })

const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});

router.post("/", function(req, res, next) {
  console.log("at login");
  var email = req.body.email;
  var timestamp = req.body.timestamp;
  var search_text = req.body.search_text;
  const query = `CALL search('${email}','${timestamp}','${search_text}')`;
  pool.query(query, (error, data) => {
    if (error) {
      res.send(error);
    } else {
      res.send("success");
    }
  });
});
module.exports = router;
