The tables contain 24 attributes. Invoice(primary key), date, store number, store name, address, city, zip code, store location, county number,
county, category, vendor name, vendor number, item number, item description, pack, bottle volume, state bottle cost, 
state bottle retail, bottles sold, sale, volume sold(Liters), volume sold(Gallons)

```Shareholders are interested in sales by county, top selling items 
Testing formatting

SELECT *
FROM liquorsales
WHERE county is NULL
GROUP BY store_number

```
