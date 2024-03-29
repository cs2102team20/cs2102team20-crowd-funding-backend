var createError = require("http-errors");
var express = require("express");
var path = require("path");
var cookieParser = require("cookie-parser");
var logger = require("morgan");

var cors = require("cors");

/* --- V7: Using dotenv     --- */
require("dotenv").config();

var indexRouter = require("./routes/index");
var usersRouter = require("./routes/users");
var projectRouter = require("./routes/projects");
var searchRouter = require("./routes/search");

/* --- V2: Adding Web Pages --- */
var aboutRouter = require("./routes/about");
/* ---------------------------- */

/* --- V3: Basic Template   --- */
var tableRouter = require("./routes/table");
var loopsRouter = require("./routes/loops");
/* ---------------------------- */

/* --- V4: Database Connect --- */
var selectRouter = require("./routes/select");
/* ---------------------------- */

/* --- V5: Adding Forms     --- */
var formsRouter = require("./routes/forms");
/* ---------------------------- */

/* --- V6: Modify Database  --- */
var insertRouter = require("./routes/insert");
/* ---------------------------- */

var loginRouter = require("./routes/login");
var createRouter = require("./routes/create");
var projectRouter = require("./routes/project");
var profileRouter = require("./routes/profile");
var editProjectRouter = require("./routes/editProject");
var editRewardRouter = require("./routes/editReward");
var feedbackRouter = require("./routes/feedback");
var updateRouter = require("./routes/updates");

var app = express();

app.use(cors());

// view engine setup
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));

app.use("/", indexRouter);
app.use("/users", usersRouter);
app.use("/projects", projectRouter);
app.use("/profile", profileRouter);
app.use("/search", searchRouter);
app.use("/editProject", editProjectRouter);
app.use("/editReward", editRewardRouter);
app.use("/feedback", feedbackRouter);
app.use("/update", updateRouter);

/* --- V2: Adding Web Pages --- */
app.use("/about", aboutRouter);
/* ---------------------------- */

/* --- V3: Basic Template   --- */
app.use("/table", tableRouter);
app.use("/loops", loopsRouter);
/* ---------------------------- */

/* --- V4: Database Connect --- */
app.use("/select", selectRouter);
/* ---------------------------- */

/* --- V5: Adding Forms     --- */
app.use("/forms", formsRouter);
/* ---------------------------- */

/* --- V6: Modify Database  --- */
var bodyParser = require("body-parser");
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use("/insert", insertRouter);
/* ---------------------------- */

app.use("/login", loginRouter);
app.use("/create", createRouter);
app.use("/project", projectRouter);

var categoriesRouter = require("./routes/categories");
app.use("/categories", categoriesRouter);

var projectsRouter = require("./routes/projects");
app.use("/projects", projectsRouter);

var walletRouter = require("./routes/wallet");
app.use("/wallet", walletRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render("error");
});

module.exports = app;
