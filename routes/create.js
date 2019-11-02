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

router.post("/", function(req, res, next) {
  var projectName = req.body.projectName;
  var projectCategory = req.body.projectCategory;
  var projectImageUrl = req.body.projectImageUrl;
  var projectDeadline = req.body.projectDeadline;
  var projectFundingGoal = req.body.projectFundingGoal;
  var projectDescription = req.body.projectDescription;
  var projectRewards = req.body.projectRewards;

  /* --- Query: Insertion into Projects --- */
  const queryProjects = `INSERT INTO projects (project_name, project_description, project_deadline, "project_category, project_funding_goal, project_current_funding, project_image_url, email)
    VALUES ('${projectName}', ${projectDescription}', '${projectDeadline}', '${projectCategory}', '${projectFundingGoal}',0,'${projectImageUrl}', 'test@test.com');`;


  pool.query(queryProjects, (error, data) => {
    if (error) {
      res.status(500),send("Unable to create project");
    } else {
      res.status(200).send("Project created!");
    }
  });
  
  /* --- Query: Insertion into Rewards --- */
  for (var i = 0; i < projectRewards.length; ) {
    let reward = projectRewards[i];
    var queryRewards = `INSERT INTO rewards (project_name, reward_name, reward_pledge_amount, reward_description)
      VALUES ('${projectName}', '${reward.rewardName}', '${reward.rewardPledgeAmount}, '${reward.rewardDescription}')`;

    pool.query(queryRewards, (error, data) => {
      if (error) {
        res.status(500),send("Unable to create project");
      } else {
        res.status(200).send("Project created!");
      }
    });
  }
  queryRewards = queryRewards.substr(0, queryRewards.length - 1);

  /* --- Final Query: Function to insert into Projects and Rewards. At the end, invoke function itself --- */
  var finalQuery = "CREATE OR REPLACE FUNCTION createProject () " +
      "RETURNS void AS $$ " +
      "BEGIN " +
      queryProjects + ";" +
      queryRewards + ";" +
      "END; " +
      "$$ LANGUAGE plpgsql; select createProject();"

});

module.exports = router;
