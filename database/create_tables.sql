DROP TABLE IF EXISTS Updates CASCADE;
DROP TABLE IF EXISTS Rewards CASCADE;
DROP TABLE IF EXISTS Feedback CASCADE;
DROP TABLE IF EXISTS Wallets CASCADE;
DROP TABLE IF EXISTS Searches CASCADE;
DROP TABLE IF EXISTS SearchHistory CASCADE;
DROP TABLE IF EXISTS Creates CASCADE;
DROP TABLE IF EXISTS Transactions CASCADE;
DROP TABLE IF EXISTS Backs CASCADE;
DROP TABLE IF EXISTS Likes CASCADE;
DROP TABLE IF EXISTS Follows CASCADE;
DROP TABLE IF EXISTS Projects CASCADE;
DROP TABLE IF EXISTS Users CASCADE;

CREATE TABLE Users (
	email varchar(255) NOT NULL PRIMARY KEY,
	full_name varchar(255) NOT NULL,
    phone_number varchar(255) NOT NULL UNIQUE,
    password_hash varchar(255) NOT NULL
);

CREATE TABLE Projects (
    project_name varchar(255) PRIMARY KEY,
    project_description text,
    project_image_url varchar(255),
    email varchar(255) REFERENCES Users(email) ON DELETE CASCADE
);

CREATE TABLE Follows (
    follower_id varchar(255) REFERENCES Users(email),
    following_id varchar(255) REFERENCES Users(email),
    CONSTRAINT follows_constraint PRIMARY KEY(follower_id, following_id)
);

CREATE TABLE Likes (
    email varchar(255) REFERENCES Users(email),
    project_name varchar(255) REFERENCES Projects(project_name),
    CONSTRAINT likes_constraint PRIMARY KEY(email, project_name)
);

CREATE TABLE Transactions (
    transaction_id serial PRIMARY KEY,
    amount numeric(20,2) NOT NULL
);

CREATE TABLE Backs (
    email varchar(255) REFERENCES Users(email),
    project_name varchar(255) REFERENCES Projects(project_name),
    transaction_id int REFERENCES Transactions(transaction_id),
        back_date timestamp NOT NULL,
    CONSTRAINT backs_constraint PRIMARY KEY(email, project_name, transaction_id)
);

CREATE TABLE Creates (
    project_name varchar(255) REFERENCES Projects(project_name),
    email varchar(255) REFERENCES Users(email),
    create_date timestamp NOT NULL,
    CONSTRAINT creates_constraint PRIMARY KEY(email, project_name)
);

CREATE TABLE SearchHistory (
    search_timestamp timestamp,
    search_text varchar(255),
    email varchar(255) REFERENCES Users(email),
    PRIMARY KEY(email,search_timestamp)
);

CREATE TABLE Searches (
    email varchar(255),
    search_timestamp timestamp,
    FOREIGN KEY (email,search_timestamp) REFERENCES SearchHistory(email,search_timestamp),
    PRIMARY KEY (email,search_timestamp)
);

CREATE TABLE Wallets (
    email varchar(255) REFERENCES Users(email) ON DELETE CASCADE,
    amount numeric NOT NULL
);

CREATE TABLE Feedback (
    project_name varchar(255) REFERENCES Projects(project_name) ON DELETE CASCADE,
    comment_text text,
    rating_number int,

    CONSTRAINT
        feedback_not_null
        CHECK (comment_text IS NOT NULL OR rating_number IS NOT NULL)
);

CREATE TABLE Rewards (
    project_name varchar(255) REFERENCES Projects(project_name) ON DELETE CASCADE,
    threshold_amount numeric(20,2),
    reward_description text,
    tier_id int,
    PRIMARY KEY(project_name, tier_id),
    CONSTRAINT
      project_tier_constraint
      UNIQUE(project_name, threshold_amount)
);

CREATE TABLE Updates (
    project_name varchar(255) REFERENCES Projects(project_name) ON DELETE CASCADE,
    update_description text,
    update_time timestamp,

    CONSTRAINT
      project_update_constraint
      PRIMARY KEY(update_time, project_name)
);
