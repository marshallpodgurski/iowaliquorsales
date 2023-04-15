Shareholders are interested learning
- What counties sold the most liquor
- How much liquor was sold($) per year
- What were the top selling items by sales($) and by volume(L)
- What type of alcohol(whiskey, gin, vodka, etc...) was most popular


#Browse and clean data

The table contains 24 attributes. **Invoice(primary key), date, store number, store name, address, city, zip code, store location, county number,
county, category, vendor name, vendor number, item number, item description, pack, bottle volume, state bottle cost, 
state bottle retail, bottles sold, sale, volume sold(Liters), volume sold(Gallons)**

After checking to make sure the data types are all okay, I look for any null values.  

```SELECT *
FROM liquorsales
WHERE invoice IS NULL```

The above query is used for each attribute, replacing "invoice" with whichever column I next search. 
Fortunately, all the attributes except "county" have no null values. 
County returned ~45000 missing values. These values will need to be found and filled in. 

There are a few ways to solve this, but I will be using the store_number column. I write a query to see how many store_numbers are represented
in the missing county values.

```
SELECT DISTINCT store_number,COUNT(store_number)
FROM liquorsales
WHERE county IS NULL
GROUP BY store_number 
```
Only 49 store numbers are returned from this query. Now that I have the store numbers, I can use them in a new query and search any invoice that 
contains them. 

```
SELECT DISTINCT county,store_number, store_name, city
FROM liquorsales
WHERE store_number=6229
```
This query returns two rows, a row with NULL in the county name and a row with the appropriate county name. Now I can update my rows with...
```
UPDATE liquorsales
SET County = 'BUENA VISTA'
WHERE store_number=6229
```
I do this for all 49 store numbers and so all 45000 missing county values are filled in. A google search tells me Iowa has 99 counties however
I notice the table recognizes 124 counties after running

```
SELECT DISTINCT county
FROM liquorsales
```
Incosistent entries (spelling, spaces, and capitalization) have caused this so time to update the table.

```
UPDATE liquorsales
SET county = UPPER(county)
```

```
UPDATE liquorsales
SET County = 'BUENA VISTA'
WHERE store_number=6229
```

So first let's determine how many counties there are in Iowa and make sure that our database matches that number. A quick internet search shows
Iowa has 

So the first thing Ill be doing is  


```
SELECT *
FROM liquorsales
WHERE county is NULL
GROUP BY store_number

```
