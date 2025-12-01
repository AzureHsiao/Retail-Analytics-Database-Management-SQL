# Create a new schema
create schema sp_conveniencestore;

# Create table_MajorProductCategory
	create table if not exists sp_conveniencestore.MajorProductCategory(
	MajorCatCD INT not null, #One raw record used a non-numeric code “Z.” We converted “Z” to 0, representing Undefined Category.
    MajorCatDESC VARCHAR(45),
	CreatedOn datetime default current_timestamp,
    ChangedOn datetime default current_timestamp,
    primary key (MajorCatCD)); 

# Create table_ProductCategory
	create table if not exists sp_conveniencestore.ProductCategory(
	CategoryCD INT not null, #1 We converted “Z” to 0, representing Undefined Category. #2 We deleted "RX" input error
    CategoryDESC VARCHAR(55), #change varchar to 55 to fit every Desc
    MajorCatCD INT not null,
	CreatedOn datetime default current_timestamp,
    ChangedOn datetime default current_timestamp,
    primary key (CategoryCD),
    foreign key (MajorCatCD) references sp_conveniencestore.MajorProductCategory(MajorCatCD)); 
    
# Create table_ProductSubCategory 
	create table if not exists sp_conveniencestore.ProductSubCategory(
	SubCatCD INT not null, #One raw record used a non-numeric code “Z.” We converted “Z” to 0, representing Undefined Category.
    SubCatDESC VARCHAR(65), #change varchar to 65
    CategoryCD INT not null,
	CreatedOn datetime default current_timestamp,
    ChangedOn datetime default current_timestamp,
    primary key (SubCatCD),
    foreign key (CategoryCD) references sp_conveniencestore.ProductCategory(CategoryCD)); 

#Create table_ProductGroup
	create table if not exists sp_conveniencestore.ProductGroup(
	ProductGroupID bigint not null, #1 Change int to bigint #2 Converted “Z” to 0, representing Undefined Category.
    ProductGroupDESC VARCHAR(70), #change varchar to 70
    SubCatCD INT not null,
	CreatedOn datetime default current_timestamp,
    ChangedOn datetime default current_timestamp,
    primary key (ProductGroupID),
    foreign key (SubCatCD) references sp_conveniencestore.ProductSubCategory(SubCatCD)); 
    
#Create table_Product
	create table if not exists sp_conveniencestore.Product(
	ProductNo bigint not null, #1 Change int to bigint #2 Converted “Z” to 0, representing Undefined Category.
    ProductDESC VARCHAR(70), #change varchar to 70
    ProductGroupID bigint not null,
	CreatedOn datetime default current_timestamp,
    ChangedOn datetime default current_timestamp,
    primary key (ProductNo),
    foreign key (ProductGroupID) references sp_conveniencestore.ProductGroup(ProductGroupID)); 
    
# Create table_StoreMaster
	create table if not exists sp_conveniencestore.StoreMaster(
	RegStoreNo int not null, # Already filtered to only North
    Region VARCHAR(10), #change varchar to 10
	CreatedOn datetime default current_timestamp,
    ChangedOn datetime default current_timestamp,
    primary key (RegStoreNo));

# Create table_Customer
CREATE TABLE sp_conveniencestore.Customer (
  CustomerID int NOT NULL,
  CustomerPhone varchar(15),
  CustomerCreditCard varchar(20),
  CreatedOn datetime DEFAULT CURRENT_TIMESTAMP,
  ChangedOn datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`CustomerID`)
);

CREATE TABLE sp_conveniencestore.Order (
  `SalesOrderID` int NOT NULL,
  `CustomerID` int NOT NULL,
  `RegStoreNo` int NOT NULL,
  `OrderDate` date, #Change MetaData to Date
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ChangedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SalesOrderID`),
  FOREIGN KEY (`CustomerID`) REFERENCES sp_conveniencestore.Customer (`CustomerID`),
  FOREIGN KEY (`RegStoreNo`) REFERENCES sp_conveniencestore.StoreMaster (`RegStoreNo`)
);

CREATE TABLE sp_conveniencestore.SalesItem (
  `SalesOrderID` int NOT NULL,
  `ProductNo` bigint NOT NULL, #Metadata changed
  `UnitPrice` decimal(13,3),
  `SalesQTY` int,
  `SalesAMT` decimal(13,3),
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ChangedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SalesOrderID`,`ProductNo`),
    foreign key (SalesOrderID) references sp_conveniencestore.Order (SalesOrderID),
	foreign key (ProductNo) references sp_conveniencestore.Product(ProductNo)
);

# Q1
# This query identifies the top 3 best-selling products in the North region. These products are recommended for stores to always keep in stock.
SELECT 
    p.ProductNo,
    p.ProductDesc,
    SUM(si.SalesQTY) AS TotalUnitsSold
FROM sp_conveniencestore.SalesItem si
JOIN sp_conveniencestore.`Order` o 
      ON si.SalesOrderID = o.SalesOrderID
JOIN sp_conveniencestore.StoreMaster sm 
      ON o.RegStoreNo = sm.RegStoreNo
JOIN sp_conveniencestore.Product p 
      ON si.ProductNo = p.ProductNo
WHERE sm.Region = 'North'
GROUP BY p.ProductNo, p.ProductDesc
ORDER BY TotalUnitsSold DESC;

#Q2 Which products should stores in the North region consider not carrying?
SELECT 
    p.ProductNo,
    p.ProductDesc,
    SUM(si.SalesQTY) AS TotalUnitsSold
FROM sp_conveniencestore.SalesItem si
JOIN sp_conveniencestore.`Order` o 
      ON si.SalesOrderID = o.SalesOrderID
JOIN sp_conveniencestore.StoreMaster sm 
      ON o.RegStoreNo = sm.RegStoreNo
JOIN sp_conveniencestore.Product p 
      ON si.ProductNo = p.ProductNo
WHERE sm.Region = 'North'
GROUP BY p.ProductNo, p.ProductDesc
ORDER BY TotalUnitsSold ASC;

# Q3
# Business Decision 1 — Identify Underperforming Stores by Total Sales
SELECT 
    sm.RegStoreNo,
    SUM(si.SalesAmt) AS TotalSales
FROM sp_conveniencestore.SalesItem si
JOIN sp_conveniencestore.`Order` o 
      ON si.SalesOrderID = o.SalesOrderID
JOIN sp_conveniencestore.StoreMaster sm
      ON sm.RegStoreNo = o.RegStoreNo
WHERE sm.Region = 'North'
GROUP BY sm.RegStoreNo
ORDER BY TotalSales ASC;

# Business Decision 2 — Identify Highest Grossing Product Categories
SELECT 
    pg.ProductGroupDesc,
    SUM(si.SalesAmt) AS TotalRevenue
FROM sp_conveniencestore.SalesItem si
JOIN sp_conveniencestore.Product p 
      ON si.ProductNo = p.ProductNo
JOIN sp_conveniencestore.ProductGroup pg
      ON p.ProductGroupID = pg.ProductGroupID
GROUP BY pg.ProductGroupDesc
ORDER BY TotalRevenue DESC;

# Business Decision 3 — Identify the Stores with the Fewest Transactions
SELECT 
    sm.RegStoreNo,
    COUNT(o.SalesOrderID) AS TotalTransactions
FROM sp_conveniencestore.`Order` o
JOIN sp_conveniencestore.StoreMaster sm
      ON o.RegStoreNo = sm.RegStoreNo
WHERE sm.Region = 'North'
GROUP BY sm.RegStoreNo
ORDER BY TotalTransactions ASC

