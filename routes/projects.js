var express = require("express");
var router = express.Router();

const { Pool } = require("pg");
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'postgres',
  password: 'password',
  port: 5432,
})

// const pool = new Pool({
//   connectionString: process.env.DATABASE_URL
// });

router.get("/", function(req, res, next) {
  var sql_query = "SELECT * FROM Projects";
  pool.query(sql_query, (error, data) => {
    if (error) {
      res.send(error);
    } else {
      res.send(data.rows);
    }
  });
});

module.exports = router;