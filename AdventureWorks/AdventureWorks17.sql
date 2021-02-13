use AdventureWorks2017;
/*
1. What are the sales, product costs, profit, number of orders & quantity ordered for internet sales by product
category and ranked by sales?
*/
Select Rank() over(order by Sales desc) as Rank , *
from 
(
select e.Name, 
       sum(a.OrderQty) 'QTY', 
	   count(distinct a.SalesOrderID) 'Number of orders' ,
	   sum(a.LineTotal) as 'Sales',
	   sum(c.StandardCost) as 'TotalCost',
	   sum(a.LineTotal) - sum(c.StandardCost)  as 'Profit'
from Sales.SalesOrderDetail a
join Sales.SalesOrderHeader b 
  on a.SalesOrderID = b.SalesOrderID
join Production.Product c
  on a.ProductID = c.ProductID
join Production.ProductSubcategory d
  on c.ProductSubcategoryID = d.ProductSubcategoryID
join Production.ProductCategory e 
  on e.ProductCategoryID = d.ProductCategoryID
where b.OnlineOrderFlag = 1
group by e.Name
)z
order by Rank;


/*
2. What are the sales, product costs, profit, number of orders & quantity ordered for reseller sales by product
category and ranked by sales?
*/

Select Rank() over(order by Sales desc) as Rank , *
from 
(
select e.Name, 
       sum(a.OrderQty) 'QTY', 
	   count(distinct a.SalesOrderID) 'Number of orders' ,
	   sum(a.LineTotal) as 'Sales',
	   sum(c.StandardCost) as 'TotalCost',
	   sum(a.LineTotal) - sum(c.StandardCost)  as 'Profit'
from Sales.SalesOrderDetail a
join Sales.SalesOrderHeader b 
  on a.SalesOrderID = b.SalesOrderID
join Production.Product c
  on a.ProductID = c.ProductID
join Production.ProductSubcategory d
  on c.ProductSubcategoryID = d.ProductSubcategoryID
join Production.ProductCategory e 
  on e.ProductCategoryID = d.ProductCategoryID
where b.OnlineOrderFlag = 0
group by e.Name
)z
order by Rank;

/*
3-What are the sales, product costs, profit, number of orders & quantity ordered for both internet & reseller sales
by product category and ranked by sales?
*/

select e.Name, 
       sum(a.OrderQty) 'QTY', 
	   count(distinct a.SalesOrderID) 'Number of orders' ,
	   sum(a.LineTotal) as 'Sales',
	   sum(c.StandardCost) as 'TotalCost',
	   sum(a.LineTotal) - sum(c.StandardCost)  as 'Profit'
from Sales.SalesOrderDetail a
join Sales.SalesOrderHeader b 
  on a.SalesOrderID = b.SalesOrderID
join Production.Product c
  on a.ProductID = c.ProductID
join Production.ProductSubcategory d
  on c.ProductSubcategoryID = d.ProductSubcategoryID
join Production.ProductCategory e 
  on e.ProductCategoryID = d.ProductCategoryID
group by e.Name 

/*
4 - What are the sales, product costs, profit, number of orders & quantity ordered for product category Accessories
broken-down by Product Hierarchy (Category, Subcategory, Model & Product) for both internet & reseller sales?
*/
select sum(a.OrderQty) 'QTY', 
	   count(distinct a.SalesOrderID) 'Number of orders' ,
	   sum(a.LineTotal) as 'Sales',
	   e.Name as 'Category' ,
	   d.Name as 'Subcategory',
	   f.Name as 'Model' ,
	   c.Name as 'Product',
	   sum(c.StandardCost) as 'TotalCost',
	   sum(a.LineTotal) - sum(c.StandardCost)  as 'Profit'
from Sales.SalesOrderDetail a
join Sales.SalesOrderHeader b 
  on a.SalesOrderID = b.SalesOrderID
join Production.Product c
  on a.ProductID = c.ProductID
join Production.ProductSubcategory d
  on c.ProductSubcategoryID = d.ProductSubcategoryID
join Production.ProductCategory e 
  on e.ProductCategoryID = d.ProductCategoryID
join Production.ProductModel f
 on c.ProductModelID = f.ProductModelID
 where e.Name = 'Accessories'
 group by e.Name , d.Name , f.Name ,c.Name
 order by Sales desc
 /*
5 - What are the sales, product costs, profit, number of orders & quantity ordered for both internet & reseller sales
by country and ranked by sales?
*/

Select Rank() over(order by Sales desc) as Rank , *
from 
(
select  
       sum(a.OrderQty) 'QTY', 
	   count(distinct a.SalesOrderID) 'Number of orders' ,
	   sum(a.LineTotal) as 'Sales',
	   d.Name as 'Country' ,
	   sum(e.StandardCost) as 'TotalCost',
	   sum(a.LineTotal) - sum(e.StandardCost)  as 'Profit'

from Sales.SalesOrderDetail a
join Sales.SalesOrderHeader b 
  on a.SalesOrderID = b.SalesOrderID
join Sales.SalesTerritory c
  on b.TerritoryID = c.TerritoryID
join Person.CountryRegion d
  on d.CountryRegionCode = c.CountryRegionCode
join Production.Product e
  on a.ProductID = e.ProductID


group by d.Name )
z
order by Rank ;


 /*
6 - What are the sales, product costs, profit, number of orders & quantity ordered for France by city and ranked by
salesfor both internet & reseller sales?
*/
Select Rank() over(order by Sales desc) as Rank , *
from 
(
select  
       sum(a.OrderQty) 'QTY', 
	   count(distinct a.SalesOrderID) 'Number of orders' ,
	   sum(a.LineTotal) as 'Sales',
	   e.City as 'City' ,
	   sum(f.StandardCost) as 'TotalCost',
	   sum(a.LineTotal) - sum(f.StandardCost)  as 'Profit'
from Sales.SalesOrderDetail a
join Sales.SalesOrderHeader b 
  on a.SalesOrderID = b.SalesOrderID
join Sales.SalesTerritory c
  on b.TerritoryID = c.TerritoryID
join Person.CountryRegion d
  on d.CountryRegionCode = c.CountryRegionCode
join Person.Address e
on b.BillToAddressID = e.AddressID
join Production.Product f
  on a.ProductID = f.ProductID
where d.Name = 'France'
group by  e.City )
z
order by Rank ;

 /*
7 - What are the top ten resellers by reseller hierarchy (business type, reseller name) ranked by sales?
*/

select * from (
SELECT RANK() OVER(ORDER BY Sum(a.linetotal) DESC) AS "Rank", vdemo.BusinessType, vdemo.Name,
           Sum(a.linetotal)  AS 'Sale'
   FROM Sales.SalesOrderDetail a
INNER JOIN Sales.SalesOrderHeader b ON a.SalesOrderID=b.SalesOrderID
INNER JOIN Sales.Customer c ON c.CustomerId=b.CustomerId
INNER JOIN Sales.Store s ON s.BusinessEntityID=c.StoreID
INNER JOIN Sales.vStoreWithDemographics vdemo ON vdemo.BusinessEntityID=s.BusinessEntityID
WHERE b.OnlineOrderFlag=0
  AND vdemo.Name=s.Name
GROUP BY vdemo.BusinessType,vdemo.Name)a
where rank<11;



 /*
 8. What are the top ten (internet) customers ranked by sales?
*/
Select top 10 Rank() over(order by Total_Sales desc) as Rank , *
from 
(
select  CONCAT(c.LastName , ', ' , c.FirstName)as 'FullName' , sum(SubTotal) as 'Total_Sales'
from Sales.SalesOrderHeader a
join Sales.Customer b
on a.CustomerID = b.CustomerID
join  Person.Person c
 on b.PersonID =c.BusinessEntityID
where  a.OnlineOrderFlag = 1
group by CONCAT(c.LastName , ', ' , c.FirstName)
)a 
order by Rank;

 /*
 9. What are the sales, product costs, profit, number of orders & quantity ordered by Customer Occupation?
*/
Select b.Occupation,
      sum(d.LineTotal) as 'TotalSales',
      count(distinct c.SalesOrderID) as 'TotalOrderCount',
      sum(d.LineTotal - e.StandardCost) as 'TotalProfit',
      sum(d.OrderQty) as 'TotalQuantity',
      sum(e.StandardCost) as 'ProductCost'
from  Sales.Customer as a
join  Sales.vPersonDemographics  b 
on a.PersonID = b.BusinessEntityID
join Sales.SalesOrderHeader  c 
on a.CustomerID = c.CustomerID
join Sales.SalesOrderDetail  d 
on c.SalesOrderID = d.SalesOrderID
join Production.Product as e 
on d.ProductID = e.ProductID
where c.OnlineOrderFlag = 1
group by b.Occupation
order by TotalSales desc

 /*
10. What are the ranked sales of the sales people (employees)?
*/

Select  Rank() over(order by Total_Sales desc) as Rank , *
from 
(
select  sum(SubTotal) as 'Total_Sales'  ,CONCAT(d.LastName , ', ' , d.FirstName) as 'FullName' 
from Sales.SalesOrderHeader a
join Sales.SalesPerson b
on b.BusinessEntityID = a.SalesPersonID
join HumanResources.Employee c
on b.BusinessEntityID = c.BusinessEntityID
join Person.Person d
on b.BusinessEntityID = d.BusinessEntityID
group by CONCAT(d.LastName , ', ' , d.FirstName)
) z
order by Rank;



 /*
11. What are the ranked sales of the sales people (employees)?
*/
select c.Category,
	   c.Type,
	   c.Description,
	   sum(a.LineTotal) as 'TotalSales',
	   sum(a.UnitPrice * a.UnitPriceDiscount) as 'DiscountAmount',
       sum(a.LineTotal - d.StandardCost) as 'Profit',
      (sum(a.UnitPrice * a.UnitPriceDiscount) / sum(a.LineTotal) )* 100 as 'Promotion Percent'
from Sales.SalesOrderDetail as a
join Sales.SalesOrderHeader as b 
on a.SalesOrderID = b.SalesOrderID
join Sales.SpecialOffer as c 
on a.SpecialOfferID = c.SpecialOfferID
join Production.Product as d 
on a.ProductID = d.ProductID
group by c.Category,c.Type,c.Description
order by TotalSales desc;



 /*
12. What are the sales, product costs, profit, number of orders & quantity ordered by Sales Territory Hierarchy
(Group, Country, region) and ranked by sales for both internet & reseller sales?
*/
Select top 10 Rank() over(order by Total_Sales desc) as Rank , *
from 
(
select e.Name as 'CountryName',
	   d."Group" as 'GroupName',
       d.Name as RegionName,
	   sum(c.StandardCost) as 'ProductCost',
	   sum(a.LineTotal - c.StandardCost) as 'TotalProfit',
	   sum(a.OrderQty) as 'TotalQuantity',
	   count( distinct a.SalesOrderID) as 'TotalNumberofOrders',
	   sum(a.LineTotal) as 'Total_Sales'
from Sales.SalesOrderDetail a
join Sales.SalesOrderHeader  b 
on a.SalesOrderID = b.SalesOrderID
join Production.Product  c 
on a.ProductID = c.ProductID
join Sales.SalesTerritory  d 
on b.TerritoryID = d.TerritoryID
join Person.CountryRegion  e 
on d.CountryRegionCode = e.CountryRegionCode
group by d."Group",e.Name,d.Name
) z
order by Rank  ;

/*
13. What are the sales by year by sales channels (internet, reseller & total)?
*/

select case when (b.OnlineOrderFlag = 0) then 'Reseller' 
            when (b.OnlineOrderFlag = 1) then 'InternetSales' end as Channel,
		    year(b.OrderDate) as 'Year',
		   sum(a.LineTotal) as 'TotalSales'
from Sales.SalesOrderDetail as a
join Sales.SalesOrderHeader as b 
on a.SalesOrderID = b.SalesOrderID
join Production.[Product] as c 
on a.ProductID = c.ProductID
join Production.[ProductSubcategory] as d 
on c.ProductSubcategoryID = d.ProductSubcategoryID
join Production.[ProductCategory] as e 
on d.ProductCategoryID = e.ProductCategoryID
group by year(b.OrderDate),b.OnlineOrderFlag

UNION
select 'Total',
		year(b.OrderDate) as 'Year',
		sum(a.LineTotal) as 'TotalSales'
from Sales.SalesOrderDetail as a
join Sales.SalesOrderHeader as b 
on a.SalesOrderID = b.SalesOrderID
join Production.Product as c
on a.ProductID = c.ProductID
join Production.ProductSubcategory as d 
on c.ProductSubcategoryID = d.ProductSubcategoryID
join Production.ProductCategory as e 
on d.ProductCategoryID = e.ProductCategoryID
group by year(b.OrderDate)

/*
14. What are the total sales by month (& year)?
*/
select year(b.OrderDate) as Year,
	   month(b.OrderDate) as Month,
      sum(a.LineTotal) as 'TotalSales'
from Sales.SalesOrderDetail  a
join Sales.SalesOrderHeader  b 
on a.SalesOrderID = b.SalesOrderID
group by year(b.OrderDate),month(b.OrderDate)
order by 'TotalSales' desc


/*
15. Please explain (briefly) the differences between SQL queries used to answer the same questions between
AdventureWorksDW2017 & AdventureWorks2017


1 - In AdventureWorksDW2017 , attributes are easily accessible. 
2 - For AdventureWorksDW2017 , one fact tables links to multiple dimension table. Efficient to query
3 - AdventureWorksDW2017 tables has more columns than AdventureWorks
4 - Tables in AdventureWorks are hierarchical like Product , ProductCategory, ProductSubcategory.
	There is no such hierarchy in DW.
	
	*/