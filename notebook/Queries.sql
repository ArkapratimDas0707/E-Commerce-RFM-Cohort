DROP TABLE IF EXISTS online_retail;

CREATE TABLE online_retail (
    InvoiceNo     VARCHAR,
    StockCode     VARCHAR,
    Description   TEXT,
    Quantity      INTEGER,
    InvoiceDate   TIMESTAMP,
    UnitPrice     NUMERIC(10, 2),
    CustomerID    NUMERIC,  -- <- changed from INTEGER
    Country       VARCHAR
);

SELECT *
FROM online_retail;

--Data Cleaning--

--Remove nulls
DELETE FROM online_retail
WHERE CustomerID IS NULL
   OR Description IS NULL
   OR TRIM(Description) = '';

--Remove negative or zeroes from Price
DELETE FROM online_retail
WHERE Quantity <= 0
   OR UnitPrice <= 0;

--Convert Timestamp to date-time

ALTER TABLE online_retail
ALTER COLUMN InvoiceDate TYPE TIMESTAMP
USING to_timestamp(InvoiceDate, 'YYYY-MM-DD HH24:MI:SS');

--Revenue Column
ALTER TABLE online_retail ADD COLUMN Revenue NUMERIC(12,2);

UPDATE online_retail
SET Revenue = Quantity * UnitPrice;

--Remove Duplicates

DELETE FROM online_retail a
USING online_retail b
WHERE a.ctid < b.ctid
  AND a.InvoiceNo = b.InvoiceNo
  AND a.StockCode = b.StockCode
  AND a.InvoiceDate = b.InvoiceDate
  AND a.CustomerID = b.CustomerID;

--Check
-- Any nulls left?
SELECT COUNT(*) FROM online_retail WHERE CustomerID IS NULL;

-- Any negatives left?
SELECT * FROM online_retail WHERE Quantity <= 0 OR UnitPrice <= 0;

-- Preview cleaned data
SELECT * FROM online_retail;

