CREATE DATABASE youtube_db;
USE youtube_db; 



-- Create tables for raw data to be loaded into
-- DROP TABLE JPvideos 
CREATE TABLE JPvideos ( 
-- RowKey INT PRIMARY KEY ,
trending_date nvarchar(50), 
title nvarchar(350),
channel_title nvarchar(350),
views nvarchar(100),
likes nvarchar(100),
dislikes nvarchar(100),
comment_count nvarchar(100)
);devideos

-- DROP TABLE DEvideos 
CREATE TABLE DEvideos (
-- RowKey INT PRIMARY KEY ,
trending_date varchar(50), 
title varchar(150),
channel_title varchar(150),
views varchar(50),
likes varchar(50),
dislikes varchar(50),
comment_count varchar(50)
);

-- DROP TABLE USvideos 
CREATE TABLE USvideos (
-- RowKey INT PRIMARY KEY ,
trending_date varchar(50), 
title varchar(150),
channel_title varchar(150),
views varchar(50),
likes varchar(50),
dislikes varchar(50),
comment_count varchar(50)
);
