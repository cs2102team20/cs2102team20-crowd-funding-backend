var express = require("express");
var router = express.Router();
const { Pool } = require("pg");

const pool = new Pool({
  //   connectionString: process.env.DATABASE_URL
  user: "postgres",
  host: "localhost",
  database: "postgres",
  password: "password",
  port: 5432
});

pool.connect();

router.post("/topup", function(req, res, next) {
  console.log("here");
  var email = req.body.email;
  var currentAmount = parseInt(req.body.currentAmount);
  var topupAmount = parseInt(req.body.topupAmount);
  var newAmount = currentAmount + topupAmount;

  console.log(req.body);

  const updateQuery = `CALL topup_wallet(${email}, ${newAmount}, ${topupAmount});`;

  pool.query(updateQuery, (error, data) => {
    if (error) {
      res.status(500).send("Internal Server Error.");
    }
  });

  const newUserDataQuery = `SELECT amount FROM Wallets WHERE email = '${email}';`;

  pool.query(newUserDataQuery, (error, data) => {
    if (error) {
      res.status(500).send("Internal Server Error.");
    } else {
      // There exists NO users entry with the given email.
      if (data.rows.count === "0") {
        res.status(404).send("Invalid User.");
      } else {
        const walletData = {
          ...data.rows[0],
          topupHistory: []
        };
        res.send(walletData);
      }
    }
  });
});

router.get("/", function(req, res, next) {
  res.send("Unauthorized");
});

module.exports = router;
