/*
  Lab 05: Implementing Rug Database
  CSC 362 Database Systems
  Christian Fronk
*/

/* Create the database (dropping the previous version if necessary */
DROP DATABASE IF EXISTS rug_store;

CREATE DATABASE rug_store;

USE rug_store;

CREATE TABLE rugs (
    PRIMARY KEY (rug_id),
    rug_id   INT AUTO_INCREMENT,
    origin_country   VARCHAR(50),
    year_made  YEAR,
    style     VARCHAR(50),
    main_material       VARCHAR(50),
    dimensions        VARCHAR(6),
    purchase_price DECIMAL(8,2),
    date_acquired     DATE,
    markup_percent DECIMAL (6,2)
);


/* Create the customers table */
CREATE TABLE customers (
    PRIMARY KEY (customer_id),
    customer_id   INT AUTO_INCREMENT,
    customer_first_name   VARCHAR(50),
    customer_last_name  VARCHAR(50),        
    customer_street_address     VARCHAR(50) NOT NULL,/* See biz rule AddressNullRule */
    customer_city               VARCHAR(50),
    customer_state               CHAR(2),
    customer_zipcode              INT,
    customer_mobile_number    VARCHAR(12) UNIQUE, /* See biz rule PhoneUniqueRule */
    is_active                BOOLEAN
);



/* Create the linking purchases table between customers and rugs */
CREATE TABLE purchases (
  PRIMARY KEY (purchase_id),
  purchase_id   INT AUTO_INCREMENT,
  customer_id         INT,
  rug_id      INT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (rug_id) REFERENCES rugs(rug_id) ON DELETE RESTRICT,/* See biz rule SaleDateRule*/
    sale_date DATE DEFAULT CURRENT_TIMESTAMP,
    sale_price DECIMAL(8,2),
    date_returned DATE CHECK (date_returned>= sale_date) /* See biz rule PurchasesReturnDateRule*/
);


/* Create trials linking table between customers and rugs*/
CREATE TABLE trials (
  PRIMARY KEY (trial_id),
  trial_id   INT AUTO_INCREMENT,
  customer_id         INT,
  rug_id      INT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (rug_id) REFERENCES rugs(rug_id) ON DELETE RESTRICT, /* See biz rule RugsDeletionRule */
    trial_start_date DATE DEFAULT CURRENT_TIMESTAMP,
    date_expected_back DATE DEFAULT DATE_ADD(CURRENT_TIMESTAMP,INTERVAL 14 DAY) CHECK (date_expected_back>trial_start_date), /* See biz rule TrialReturnandStartDateRule */
    trial_date_returned DATE CHECK (trial_date_returned >= trial_start_date) /* See biz rule TrialReturnandStartDateRule */
);


/* Populate tables*/
INSERT INTO rugs (origin_country, year_made, style,main_material,dimensions,purchase_price,date_acquired,markup_percent)
VALUES ('Turkey','1925','Ushak','Wool','5x7','625.00','2017-4-6','1'),
       ('Iran','1910','Tabriz','Silk','10x14','28000.00','2017-4-6','.75'),
       ('India','2017','Agra','Wool','8x10','1200.00','2017-6-15','1'),
       ('India','2017','Agra','Wool','4x6','450.00','2017-6-15','1.2');

INSERT INTO customers (customer_first_name, customer_last_name, customer_street_address,customer_city,customer_state,customer_zipcode,customer_mobile_number,is_active)
VALUES ('Akira','Ingram','68 Country Drive','Roseville','MI','48066','926-252-6716','1'),
       ('Meredith','Spencer','9044 Piper Lane','North Royalton','OH','44133','817-530-5994','1');

INSERT INTO purchases (customer_id, rug_id, sale_date,sale_price,date_returned)
VALUES ('2','1','2017-12-14','990',NULL),
       ('1','2','2017-12-17','1300',NULL);

INSERT INTO trials (customer_id, rug_id,trial_start_date,date_expected_back,trial_date_returned)
VALUES ('2','3','2017-12-14','2017-12-25','2017-12-26'),
       ('1','4','2017-12-16','2017-12-27','2017-12-28');



CREATE VIEW rugs_list_price_view AS SELECT rugs.rug_id, rugs.purchase_price,rugs.markup_percent,(rugs.purchase_price+(rugs.purchase_price*rugs.markup_percent)) AS list_price
FROM  rugs;

CREATE VIEW net_profit_view AS SELECT rugs.rug_id, rugs.purchase_price,purchases.sale_price,(purchases.sale_price-rugs.purchase_price) AS net_profit
FROM  rugs
INNER JOIN purchases ON purchases.rug_id = rugs.rug_id;

