Shareholders are interested in learning
1. Liquor sold per county
2. How much liquor was sold in each year
3. What were the top selling items by sales count and by volume(L)
4. What type of alcohol(whiskey, gin, vodka, etc...) was most popular


## Browse and clean data

The table contains 24 attributes. The relevant ones needed for our project are 

**invoice(primary key)** - every liquor purchase has it's own unique invoice number

**date** - date of purchase 

**store_number** - every store has it's own unique ID number

**store_name**  , county number,

**county** -  name of the county where purchase took place

**county_number** - each county has it's own unique ID number 

**category** - seven digit number that categorizes what type of alcohol is sold. More about this at prompt #4 

**vendor_name** - company name that own's the brand (Luxco Inc, Diageo Americas, Sazerac Company Inc, etc) 

**vendor_number** - each vendor name has it's own unique ID number

**item_description** - What product is being sold (Hawkeye's Vodka, Crown Royale, Grey Goose)

**item_number** - each specific product has it's own unique ID number (Tito's Vodka 750ml bottle and a Tito Vodka 1L bottle will have different numbers) 

**bottle_volume** 

**state_bottle_cost** - how much the store paid for it from the supplier

**state_bottle_retail** - how much the store sold it for

**sale** 

**volume_sold(Liters)** 

Other attributes not needed but useful - address, city, zip_code, store_location,pack, bottles_sold, volume_sold(Gallons)


-------------------------------------------

To start, I'm going to look for any null values. The below query is used and the WHERE clause modified for each attribute. 

```
SELECT *
FROM liquorsales
WHERE invoice IS NULL
```

Fortunately, all the attributes except "county" have no null values. 
County returned ~45,000 missing values. These values will need to be filled in. 

There are a few ways to solve this, but I will be using the store_number column. I write a query to see how many store_numbers are represented
by the NULL county values.

```
SELECT DISTINCT store_number,COUNT(store_number)
FROM liquorsales
WHERE county IS NULL
GROUP BY store_number 
```
49 store numbers are returned from this query. Now that I have the store numbers, I can use them to search for any invoice that 
contains them. 

```
SELECT DISTINCT county,store_number, store_name, city
FROM liquorsales
WHERE store_number=6229
```
This query returns two rows, a row with NULL in the county name and a row with the appropriate county name. Now that I have found the proper
county name for the store numbers, I can update my rows with...

```
UPDATE liquorsales
SET County = 'BUENA VISTA'
WHERE store_number=6229
```

I do these series of queries for all 49 store numbers and so all 45,000 missing county values are filled in. 

To double check my work, I Google and see that Iowa has 99 counties however the table recognizes 124 counties after running the next query. 

```
SELECT DISTINCT county
FROM liquorsales
```
This is due to incosistent entries (spelling, spaces, and capitalization) so need to update the table.

```
UPDATE liquorsales
SET county = UPPER(county)
```

```
UPDATE liquorsales
SET county = 'CERRO GORD'
WHERE county= 'CERROGORD'
```
Our distinct counties query now returns the correct number of 99 and we can answer the first question from the stakeholder 

## 1. Liquor sold per county

```
SELECT DISTINCT county, SUM(sale)as SaleByCounty
FROM liquorsales
GROUP BY county
```
## 2. How much liquor was sold in each year

```
SELECT YEAR(date) AS year, SUM(sale_price) AS total_sales
FROM liquorsales 
WHERE YEAR(date) IN (2019, 2020, 2021)
GROUP BY YEAR(date)
```
## 3. What were the top selling items by sales count and by volume(L)

Top Items by Sales Count
```
SELECT item_description,vendor_name,pack,bottle_volume, item_number,COUNT(*)
FROM liquorsales
GROUP BY item_number
ORDER BY COUNT(*) DESC
LIMIT 10
```
Top Items by Total Volume
```
SELECT item_description,vendor_name,SUM(bottle_volume) as total_volume
FROM liquorsales
GROUP BY item_description
ORDER BY total_volume DESC
LIMIT 10
```
## 4. What type of alcohol(whiskey, gin, vodka, etc...) was most popular

The attribute "category" uses a numeric code to log what type of alcohol the liquor. Numbers that begin with 101 are Whiskey, 102 are 
Tequila/Mezcal, 103 are Vodka, etc.

I wrote two queries that add a new column called **alcohol_type** and translates the category numeric code into a string value (whiskey, vodka, etc) 

```
UPDATE liquorsales
ADD COLUMN alcohol_type CHAR
```

```
UPDATE liquorsales
   SET alcohol_type =
       CASE WHEN category >= 1070000
            THEN 'Other (Spirits, Liqueurs, Cocktails)'
            WHEN category >= 1060000
            THEN 'Rum'
            WHEN category >= 1050000
            THEN 'Brandy'
            WHEN category >= 1040000
            THEN 'Gin'
            WHEN category >= 1030000
            THEN 'Vodka'
            WHEN category >= 1020000
            THEN 'Tequlia/Mezcal'
            WHEN category >= 1010000
            THEN 'Whiskey'
            ELSE 'Other (Spirits, Liqueurs, Cocktails)'
        END
```

After reading this, check out the dashboard created using this data back in the repository

