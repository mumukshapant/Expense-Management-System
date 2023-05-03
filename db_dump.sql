CREATE DATABASE  IF NOT EXISTS `expense_management_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `expense_management_system`;
-- MySQL dump 10.13  Distrib 8.0.29, for macos12 (x86_64)
--
-- Host: localhost    Database: expense_management_system
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_name` varchar(255) NOT NULL,
  PRIMARY KEY (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES ('Clothing'),('Deposit'),('Donations'),('Education'),('Electronics'),('Entertainment'),('Food'),('Health care'),('Housing'),('Personal Care Items'),('Savings and investment'),('Shopping'),('Transport');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currency`
--

DROP TABLE IF EXISTS `currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currency` (
  `currency_name` varchar(50) NOT NULL,
  `abbreviation` varchar(3) NOT NULL,
  `rate` decimal(8,6) DEFAULT NULL,
  PRIMARY KEY (`abbreviation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currency`
--

LOCK TABLES `currency` WRITE;
/*!40000 ALTER TABLE `currency` DISABLE KEYS */;
INSERT INTO `currency` VALUES ('Australian Dollar','AUD',0.720000),('Brazilian Real','BRL',0.240000),('Canadian dollar','CAD',0.800000),('Chinese Yuan','CNY',0.160000),('Euro','EUR',1.170000),('British Pound Sterling','GBP',1.400000),('Hong Kong Dollar','HKD',1.300000),('Indian Rupee','INR',0.013000),('Japanese Yen','JPY',0.008900),('South Korean Won','KRW',0.000850),('Russian Ruble','RUB',0.014000),('Swedish Krona','SEK',0.120000),('Turkish Lira','TRY',0.120000),('United States Dollar','USD',1.000000),('South African Rand','ZAR',0.070000);
/*!40000 ALTER TABLE `currency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deposit`
--

DROP TABLE IF EXISTS `deposit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deposit` (
  `deposit_id` int NOT NULL AUTO_INCREMENT,
  `amount` decimal(19,4) NOT NULL,
  `description` varchar(255) NOT NULL,
  `currency` varchar(3) NOT NULL,
  `deposit_date` date DEFAULT NULL,
  `user_name` varchar(255) NOT NULL,
  PRIMARY KEY (`deposit_id`),
  KEY `deposit_user_fk` (`user_name`),
  KEY `deposit_currency_fk` (`currency`),
  CONSTRAINT `deposit_currency_fk` FOREIGN KEY (`currency`) REFERENCES `currency` (`abbreviation`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `deposit_user_fk` FOREIGN KEY (`user_name`) REFERENCES `user` (`user_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deposit`
--

LOCK TABLES `deposit` WRITE;
/*!40000 ALTER TABLE `deposit` DISABLE KEYS */;
INSERT INTO `deposit` VALUES (16,6000.0000,'Internation money transfer','USD','2023-03-31','dhruv'),(22,100.0000,'New Deposit','USD','2023-04-11','mumuksha'),(31,10000.0000,'Deposit from India','INR','2023-04-19','dhruv');
/*!40000 ALTER TABLE `deposit` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_deposit_delete` BEFORE DELETE ON `deposit` FOR EACH ROW BEGIN
  -- insert into history table
DECLARE new_history_id INT;
INSERT INTO `expense_management_system`.`logit_history`
(`amount`,`description`,`currency`,`creation_date`,`category`,`history_type`)
VALUES
(old.amount,
old.description,
old.currency,
old.deposit_date,
null,
"Deposit");

  -- Get the ID of the newly inserted expense    
SET new_history_id = LAST_INSERT_ID();

  -- insert into historyuser table to represent many-to-many mapping
  INSERT INTO user_logit_history (logit_history_id,user_name,amount )
  SELECT new_history_id,user_name,amount
  FROM deposit
  WHERE deposit_id = OLD.deposit_id;
  
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `expense`
--

DROP TABLE IF EXISTS `expense`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense` (
  `expense_id` int NOT NULL AUTO_INCREMENT,
  `amount` decimal(19,4) NOT NULL,
  `description` varchar(255) NOT NULL,
  `currency` varchar(3) NOT NULL,
  `creation_date` date DEFAULT NULL,
  `category` varchar(255) NOT NULL,
  `shared_count` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`expense_id`),
  KEY `expense_categories_fk` (`category`),
  KEY `expense_currency_fk` (`currency`),
  CONSTRAINT `expense_categories_fk` FOREIGN KEY (`category`) REFERENCES `categories` (`category_name`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `expense_currency_fk` FOREIGN KEY (`currency`) REFERENCES `currency` (`abbreviation`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expense`
--

LOCK TABLES `expense` WRITE;
/*!40000 ALTER TABLE `expense` DISABLE KEYS */;
INSERT INTO `expense` VALUES (112,12.1212,'Notebook ','USD','2023-04-18','Education',1),(129,72.0000,'samosa','INR','2023-04-19','Food',1),(135,2.0000,'Pizza two tomatoes','USD','2023-04-19','Food',2),(137,80.0000,'zara shopping','USD','2023-04-19','Clothing',2);
/*!40000 ALTER TABLE `expense` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_expense_delete` BEFORE DELETE ON `expense` FOR EACH ROW BEGIN
  -- insert into history table
  DECLARE new_history_id INT;
INSERT INTO `expense_management_system`.`logit_history`
(`amount`,`description`,`currency`,`creation_date`,`category`,`shared_count`,`history_type`)
VALUES
(old.amount,
old.description,
old.currency,
old.creation_date,
old.category,
old.shared_count,
"Expense");

  -- Get the ID of the newly inserted expense    
SET new_history_id = LAST_INSERT_ID();

  -- insert into historyuser table to represent many-to-many mapping
  INSERT INTO user_logit_history (logit_history_id,user_name,amount )
  SELECT new_history_id,user_name,amount
  FROM user_expense 
  WHERE expense_id = OLD.expense_id;
  
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `feedbacks`
--

DROP TABLE IF EXISTS `feedbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedbacks` (
  `feedback_id` int NOT NULL AUTO_INCREMENT,
  `is_query` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL,
  `creation_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `user_name` varchar(255) DEFAULT NULL,
  `user_email_address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`feedback_id`),
  KEY `feedback_user_fk` (`user_name`),
  CONSTRAINT `feedback_user_fk` FOREIGN KEY (`user_name`) REFERENCES `user` (`user_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedbacks`
--

LOCK TABLES `feedbacks` WRITE;
/*!40000 ALTER TABLE `feedbacks` DISABLE KEYS */;
INSERT INTO `feedbacks` VALUES (64,0,'Amazing application ! ','2023-04-18 21:45:10','dhruv','dhruvsaini1997@gmail.com'),(65,1,'How to use split in expense?','2023-04-18 21:49:12','dhruv','dhruvsaini1997@gmail.com'),(73,0,'feedback','2023-04-19 16:32:04','mumuksha','MUMUKSHAPAN97@GMAIL.COM');
/*!40000 ALTER TABLE `feedbacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logit_history`
--

DROP TABLE IF EXISTS `logit_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logit_history` (
  `logit_history_id` int NOT NULL AUTO_INCREMENT,
  `amount` decimal(19,4) NOT NULL,
  `description` varchar(255) NOT NULL,
  `currency` varchar(3) NOT NULL,
  `creation_date` date DEFAULT NULL,
  `deletion_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `category` varchar(255) DEFAULT NULL,
  `shared_count` int NOT NULL DEFAULT '1',
  `history_type` varchar(50) NOT NULL,
  PRIMARY KEY (`logit_history_id`),
  KEY `logit_history_categories_fk` (`category`),
  KEY `logit_history_currency_fk` (`currency`),
  CONSTRAINT `logit_history_categories_fk` FOREIGN KEY (`category`) REFERENCES `categories` (`category_name`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `logit_history_currency_fk` FOREIGN KEY (`currency`) REFERENCES `currency` (`abbreviation`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=160 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logit_history`
--

LOCK TABLES `logit_history` WRITE;
/*!40000 ALTER TABLE `logit_history` DISABLE KEYS */;
INSERT INTO `logit_history` VALUES (158,1000.0000,'New Laptop ','USD','2023-04-18','2023-04-20 11:07:40','Electronics',1,'Expense'),(159,100.0000,'New Deposit','USD','2023-03-28','2023-04-20 11:12:33',NULL,1,'Deposit');
/*!40000 ALTER TABLE `logit_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_name` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email_address` varchar(255) NOT NULL,
  `contact_number` mediumtext NOT NULL,
  `gender` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `domestic_currency` varchar(3) DEFAULT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_name`),
  KEY `user_currency_fk` (`domestic_currency`),
  CONSTRAINT `user_currency_fk` FOREIGN KEY (`domestic_currency`) REFERENCES `currency` (`abbreviation`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('admin1','admin','1','admin1@neu.edu','1212212','MALE','2023-04-15','USD',1),('dhruv','Dhruv','Sainiii','dhruvsaini1997@gmail.com','9899224840','MALE','1997-11-04','USD',0),('mumuksha','Mumuksha','Pant','MUMUKSHAPAN97@GMAIL.COM','7550173236','FEMALE','1997-12-11','USD',0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `delete_user_expenses` BEFORE DELETE ON `user` FOR EACH ROW BEGIN 
    DELETE FROM expense 
    WHERE expense_id in (select expense_id from user_expense where user_name = OLD.user_name) and shared_count =1; 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user_expense`
--

DROP TABLE IF EXISTS `user_expense`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_expense` (
  `user_name` varchar(255) NOT NULL,
  `expense_id` int NOT NULL,
  `amount` int NOT NULL,
  PRIMARY KEY (`user_name`,`expense_id`),
  KEY `user_expense_table_user_fk` (`user_name`),
  KEY `user_expense_table_expense_fk` (`expense_id`),
  CONSTRAINT `user_expense_table_expense_fk` FOREIGN KEY (`expense_id`) REFERENCES `expense` (`expense_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_expense_table_user_fk` FOREIGN KEY (`user_name`) REFERENCES `user` (`user_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_expense`
--

LOCK TABLES `user_expense` WRITE;
/*!40000 ALTER TABLE `user_expense` DISABLE KEYS */;
INSERT INTO `user_expense` VALUES ('dhruv',112,12),('dhruv',135,1),('dhruv',137,40),('mumuksha',129,72),('mumuksha',135,1),('mumuksha',137,40);
/*!40000 ALTER TABLE `user_expense` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_logit_history`
--

DROP TABLE IF EXISTS `user_logit_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_logit_history` (
  `user_name` varchar(255) NOT NULL,
  `logit_history_id` int NOT NULL,
  `amount` int NOT NULL,
  PRIMARY KEY (`user_name`,`logit_history_id`),
  KEY `user_logit_history_table_user_fk` (`user_name`),
  KEY `user_logit_history_table_logit_history_fk` (`logit_history_id`),
  CONSTRAINT `user_logit_history_table_logit_history_fk` FOREIGN KEY (`logit_history_id`) REFERENCES `logit_history` (`logit_history_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `user_logit_history_table_user_fk` FOREIGN KEY (`user_name`) REFERENCES `user` (`user_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_logit_history`
--

LOCK TABLES `user_logit_history` WRITE;
/*!40000 ALTER TABLE `user_logit_history` DISABLE KEYS */;
INSERT INTO `user_logit_history` VALUES ('dhruv',158,1000),('dhruv',159,100);
/*!40000 ALTER TABLE `user_logit_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'expense_management_system'
--

--
-- Dumping routines for database 'expense_management_system'
--
/*!50003 DROP FUNCTION IF EXISTS `convertUSDtoDomesticCurr` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `convertUSDtoDomesticCurr`( amount decimal(20,4), domestic_curr varchar(3)) RETURNS decimal(20,4)
    DETERMINISTIC
BEGIN
declare domestic_rate decimal(20,4);
set domestic_rate = (select rate from currency where abbreviation =domestic_curr);
return CAST(amount/domestic_rate as decimal(18,4));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `calculate_user_expense` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_user_expense`(IN p_username varchar(128), OUT balance decimal(10,4))
BEGIN
   DECLARE total_usd DECIMAL(18, 4) default 0;
   DECLARE local_amount decimal(18,4) default 0;
   DECLARE domestic_curr varchar(3);
   
   CREATE TEMPORARY TABLE if not exists temp_user_expense (amount decimal(18,4));
-- get expenses 
   insert into temp_user_expense 

   select CAST(-1 * ue.amount * c.rate AS DECIMAL(18, 4))  FROM user_expense ue join expense e on e.expense_id = ue.expense_id join currency c on c.abbreviation = e.currency
   WHERE ue.user_name = p_username;
   select * from temp_user_expense;
-- get deposits
   insert into temp_user_expense select  CAST(d.amount * c.rate as DECIMAL(18,4))  FROM deposit d join user u on d.user_name = u.user_name join currency c on c.abbreviation = d.currency 
    WHERE d.user_name = p_username;
    
    -- get total in USD 
    
    SET @total_usd = (select CAST(sum(amount) as decimal(18,4)) from temp_user_expense);
	select @total_usd;
    -- now coverting USD to local user currency 
    
    set @domestic_curr = (select domestic_currency from user where user_name = p_username); 
    select @domestic_curr;
    set @local_amount = convertUSDtoDomesticCurr(@total_usd,@domestic_curr);
    select @local_amount;
    IF @local_amount IS NULL THEN
         SET @local_amount = 0;
	END IF;
    set balance = @local_amount;
    drop temporary table temp_user_expense;
    select balance;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_category` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_category`(
  IN name varchar(255),
  OUT rowsAffected int
)
BEGIN
   insert into categories(category_name) values (name);
   SET rowsAffected = ROW_COUNT();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_currency` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_currency`(
	  IN currency_name varchar(255),
      IN abbreviation varchar(3),
      IN rate decimal(4,2),
	  OUT rowsAffected int
	)
BEGIN
	   insert into currency (currency_name, abbreviation, rate) values (currency_name,abbreviation,rate);
	   SET rowsAffected = ROW_COUNT();
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_user`(
 IN user_name varchar(255),
 IN first_name varchar(255),
 IN last_name varchar(255),
 IN email_address varchar(255),
 IN gender varchar(10),
 IN contact_number mediumtext,
 IN date_of_birth date,
 IN domestic_currency varchar(3),
 In is_admin boolean ,
 OUT rowsAffected int
)
BEGIN

INSERT INTO `expense_management_system`.`user`
(`user_name`,
`first_name`,
`last_name`,
`email_address`,
`contact_number`,
`gender`,
`date_of_birth`,
`domestic_currency`,
`is_admin`)
VALUES
(user_name,
first_name,
last_name,
email_address,
contact_number,
gender,
date_of_birth,
domestic_currency,
is_admin);

SET rowsAffected = ROW_COUNT();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_category` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_category`(IN name varchar(255),OUT rowsAffected int)
BEGIN
    DECLARE Deleted INT;
    START TRANSACTION;
    
    IF NOT EXISTS (
        SELECT *
	   FROM expense
        WHERE category = name 
        union
        SELECT *
        FROM   logit_history
        WHERE category = name 
    )
    THEN
    
        DELETE FROM Categories
        WHERE category_name = name;

    END IF;
    SET rowsAffected = ROW_COUNT();
    COMMIT;
   --  select Deleted as Deleted;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_currency` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_currency`(
  IN abb varchar(3),
  OUT rowsAffected int)
BEGIN
	
    START TRANSACTION;
    
    IF NOT EXISTS (
        SELECT *
        FROM expense
        WHERE currency = abb
        union
        SELECT *
        FROM deposit
        WHERE currency = abb
        union 
        select * from logit_history where currency = abb
        union
        select * from user where domestic_currency =abb
    )
    THEN
    
        DELETE FROM currency
        WHERE abbreviation = abb;

    END IF;
    SET rowsAffected = ROW_COUNT();
  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_deposit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_deposit`(
	  IN specific_deposit_id int,
	  OUT rowsAffected int
	)
BEGIN
	   DELETE FROM deposit WHERE deposit_id = specific_deposit_id;
	   SET rowsAffected = ROW_COUNT();
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_expense` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_expense`(
	  IN specific_expense_id int,
	  OUT rowsAffected int
	)
BEGIN
	   DELETE FROM expense WHERE expense_id = specific_expense_id;
	   SET rowsAffected = ROW_COUNT();
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_feedback` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_feedback`(IN id int
,OUT rowsAffected int)
BEGIN
    DECLARE Deleted INT;
    START TRANSACTION;
	delete from feedbacks where feedback_id = id;
    SET rowsAffected = ROW_COUNT();
    COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_user`(
  IN username varchar(255)      ,
  OUT rowsAffected int
)
BEGIN
  -- SET SQL_SAFE_UPDATES = 0;
  delete from user where user_name = username;
   SET rowsAffected = ROW_COUNT();
  -- SET SQL_SAFE_UPDATES = 1;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `find_expense_by_username` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `find_expense_by_username`(
  IN user_name varchar(255)       
)
BEGIN

  
    SELECT e.*,
    eu.amount as actual_total
    FROM expense e
    JOIN user_expense eu ON e.expense_id = eu.expense_id
    JOIN user u ON eu.user_name = u.user_name
    WHERE eu.user_name = user_name;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `find_feedbacks` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `find_feedbacks`()
BEGIN 
    SELECT f.*
    FROM feedbacks f 
    JOIN user u ON u.user_name = f.user_name
        WHERE  is_query=0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `find_history_by_username` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `find_history_by_username`(
  IN user_name varchar(255)       
)
BEGIN

  
    SELECT h.*,
    ulh.amount as actual_total
    FROM logit_history h
    JOIN user_logit_history ulh ON h.logit_history_id = ulh.logit_history_id
    JOIN user u ON ulh.user_name = u.user_name
    WHERE ulh.user_name = user_name;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `find_queries` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `find_queries`()
BEGIN 
    SELECT f.*
    FROM feedbacks f 
    JOIN user u ON u.user_name = f.user_name
        WHERE  is_query=1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `find_users_with_feedback` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `find_users_with_feedback`()
BEGIN
  SELECT DISTINCT u.*
  FROM user u
  INNER JOIN feedbacks f ON u.email_address = f.email
  ORDER BY u.last_name, u.first_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getUserDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserDetails`(IN puser_name VARCHAR(255))
BEGIN
    SELECT email_address FROM user WHERE user_name = puser_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_deposit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_deposit`(
    IN description VARCHAR(255),
    IN amount decimal(19,4),
    IN currency varchar(3),
    IN deposit_date date,
    IN user_name varchar(255),
      OUT rowsAffected int
)
BEGIN

INSERT INTO `expense_management_system`.`deposit`
(`amount`,`description`,`currency`,`deposit_date`,`user_name`)
VALUES
(amount, description, currency, deposit_date, user_name);
SET rowsAffected = ROW_COUNT();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_expense` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_expense`( IN amount decimal(19,4),
IN description VARCHAR(255),
IN currency varchar(3),
IN creation_date date,
IN category varchar(255),
IN p_usernames varchar(255),
OUT rowsAffected INT
)
BEGIN

DECLARE user_count INT;
DECLARE amount_per_user DECIMAL(19, 4);
DECLARE user_name_table VARCHAR(100);
DECLARE new_expense_id INT;
DECLARE user_name_iter varchar(20);
Declare rowsAdd int;


START TRANSACTION;

CREATE TEMPORARY TABLE if not exists temp_user_names (user_name varchar(20));
SET user_name_table = p_usernames;

WHILE user_name_table != '' DO
	SET user_name_iter = SUBSTRING_INDEX(user_name_table, ',', 1);
    SET user_name_table = SUBSTR(user_name_table, LENGTH(user_name_iter) + 2);
    
    INSERT INTO temp_user_names (user_name) VALUES (user_name_iter);
 END WHILE;

SET user_count = (select count(*) from temp_user_names);

-- Insert the new expense record
INSERT INTO `expense_management_system`.`expense`
(
`amount`,
`description`,
`currency`,
`creation_date`,
`category`,
`shared_count`)
VALUES
(
amount,
description,
currency,
creation_date,
category,
user_count);

set rowsAdd = @rowCount;

IF (@rowsAdd != 1) THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Failed to insert into expense table';
END IF;

-- Get the ID of the newly inserted expense    
SET new_expense_id = LAST_INSERT_ID();

-- Calculate the amount each user should pay for the expense
SET amount_per_user = amount / (SELECT COUNT(*) FROM temp_user_names);

-- Insert records into the user_expense table for each user
WHILE EXISTS (SELECT * FROM temp_user_names) DO
 SELECT user_name FROM temp_user_names  LIMIT 1 INTO user_name_iter;
 
 SET SQL_SAFE_UPDATES = 0;
 DELETE FROM temp_user_names WHERE user_name = user_name_iter;
 SET SQL_SAFE_UPDATES  =1;
 
 INSERT INTO user_expense (user_name, expense_id, amount)VALUES (user_name_iter, new_expense_id, amount_per_user);
 SET @rowCount =  ROW_COUNT();
 
 IF (@rowCount != 1) THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Failed to insert into user_expense table';
END IF;

END WHILE;

-- Drop the temporary table
DROP TEMPORARY TABLE if exists temp_user_names;
-- Commit the transaction
SET rowsAffected = 1;
COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_feedback` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_feedback`(
 IN is_query boolean,
 IN description varchar(255),
 IN user_name varchar(255),
 IN user_email_address varchar(255),
 OUT rowsAffected int
)
BEGIN

INSERT INTO `expense_management_system`.`feedbacks`
(`is_query`,`description`, `user_name`, `user_email_address` )
VALUES
(is_query, description, user_name, user_email_address);
SET rowsAffected = ROW_COUNT();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_category` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_category`(
  IN oldName varchar(255),
  IN newName varchar(255),
  OUT rowsAffected int
)
BEGIN
  update categories set category_name = newName where category_name = oldName;
   SET rowsAffected = ROW_COUNT();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_currency` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_currency`(
  IN newCurrencyName varchar(255),
  IN abb varchar(255), 
  IN newRate decimal (8,6),
  OUT rowsAffected int
)
BEGIN

  update currency set currency_name = newCurrencyName  , rate= newRate  where abbreviation = abb;
 SET rowsAffected = ROW_COUNT();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user`(
 IN p_user_name varchar(255),
 IN first_name varchar(255),
 IN last_name varchar(255),
 IN email_address varchar(255),
 IN gender varchar(10),
 IN contact_number mediumtext,
 IN date_of_birth date,
 IN domestic_currency varchar(3),
 OUT rowsAffected int
)
BEGIN

update  `expense_management_system`.`user`
set `first_name` = first_name,
 `last_name`= last_name,
`email_address` = email_address ,
`contact_number` = contact_number,
`gender` =gender,
`date_of_birth` = date_of_birth,
`domestic_currency` = domestic_currency
where user_name = p_user_name;

SET rowsAffected = ROW_COUNT();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-20 12:12:06
