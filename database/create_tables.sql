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
    user_id serial PRIMARY KEY,
	email varchar(255) NOT NULL UNIQUE,
	full_name varchar(255) NOT NULL,
    phone_number varchar(255) NOT NULL UNIQUE,
    password_hash varchar(255) NOT NULL
);

CREATE TABLE Projects (
    project_name varchar(255) PRIMARY KEY,
    project_description text,
    project_image_url varchar(255),
    user_id int REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Follows (
    follower_id int REFERENCES Users(user_id),
    following_id int REFERENCES Users(user_id),
    CONSTRAINT follows_constraint PRIMARY KEY(follower_id, following_id)
);

CREATE TABLE Likes (
    user_id int REFERENCES Users(user_id),
    project_name varchar(255) REFERENCES Projects(project_name),
    CONSTRAINT likes_constraint PRIMARY KEY(user_id, project_name)
);

CREATE TABLE Transactions (
    transaction_id serial PRIMARY KEY,
    amount numeric(20,2) NOT NULL
);

CREATE TABLE Backs (
    user_id int REFERENCES Users(user_id),
    project_name varchar(255) REFERENCES Projects(project_name),
    transaction_id int REFERENCES Transactions(transaction_id),
        back_date timestamp NOT NULL,
    CONSTRAINT backs_constraint PRIMARY KEY(user_id, project_name, transaction_id)
);

CREATE TABLE Creates (
    project_name varchar(255) REFERENCES Projects(project_name),
    user_id int REFERENCES Users(user_id),
    create_date timestamp NOT NULL,
    CONSTRAINT creates_constraint PRIMARY KEY(user_id, project_name)
);

CREATE TABLE SearchHistory (
    search_timestamp timestamp,
    search_text varchar(255),
    user_id int REFERENCES Users(user_id),
    CONSTRAINT searchhistory_timestamp PRIMARY KEY(user_id, search_timestamp)
);

CREATE TABLE Searches (
    search_timestamp timestamp REFERENCES SearchHistory(search_timestamp),
    user_id int REFERENCES Users(user_id),
    CONSTRAINT searches_constraint PRIMARY KEY(user_id, search_timestamp)
);

CREATE TABLE Wallets (
    user_id int REFERENCES Users(user_id) ON DELETE CASCADE,
    amount numeric NOT NULL
);

CREATE TABLE Feedback (
    project_id int REFERENCES Projects(project_id) ON DELETE CASCADE,
    comment_text text,
    rating_number int,

    CONSTRAINT
        feedback_not_null
        CHECK (comment_text IS NOT NULL OR rating_number IS NOT NULL)
);

CREATE TABLE Rewards (
    project_id int REFERENCES Projects(project_id) ON DELETE CASCADE,
    threshold_amount numeric(20,2),
    reward_description text,
    PRIMARY KEY(project_id, tier_id),
    CONSTRAINT
      project_tier_constraint
      UNIQUE(project_id, threshold_amount)
);

CREATE TABLE Updates (
    project_id int REFERENCES Projects(project_id) ON DELETE CASCADE,
    update_description text,
    update_date date,

    CONSTRAINT
      project_update_constraint
      PRIMARY KEY(update_id, project_id)
);
