use AdventureWorksDW2017;
/*
1 - What are the sales, product costs, profit, number of orders & quantity ordered for internet sales by product
category and ranked by sales?
*/
Select Rank() over(order by Sales desc) as Rank , *
from 
(
select sum (a.SalesAmount) as 'Sales',
       sum(a.TotalProductCost) as 'Product Cost' ,
	  (sum(a.SalesAmount) - sum(a.TotalProductCost) ) as 'Profit',
	  count(distinct a.SalesOrderNumber) as 'Number of Orders',
	  sum(a.OrderQuantity) as 'Quantity',
	  d.EnglishProductCategoryName as 'Product Category'
from FactInternetSales a
join DimProduct b
on a.ProductKey = b.ProductKey
join DimProductSubcategory c
on b.ProductSubcategoryKey = c.ProductSubcategoryKey
join DimProductCategory d
on d.ProductCategoryKey = c.ProductCategoryKey
group by d.EnglishProductCategoryName
)a
order by Rank;


/*
2 -What are the sales, product costs, profit, number of orders & quantity ordered for reseller sales by product
category and ranked by sales?
*/
Select Rank() over(order by Sales desc) as Rank , *
from 
(
select sum (a.SalesAmount) as 'Sales',
       sum(a.TotalProductCost) as 'Product Cost' ,
	  (sum(a.SalesAmount) - sum(a.TotalProductCost) ) as 'Profit',
	  count(distinct a.SalesOrderNumber) as 'Number of Orders',
	  sum(a.OrderQuantity) as 'Quantity',
	  d.EnglishProductCategoryName as 'Product Category'
from FactResellerSales a
join DimProduct b
on a.ProductKey = b.ProductKey
join DimProductSubcategory c
on b.ProductSubcategoryKey = c.ProductSubcategoryKey
join DimProductCategory d
on d.ProductCategoryKey = c.ProductCategoryKey
group by d.EnglishProductCategoryName
) a
order by Rank;

/*
3. What are the sales, product costs, profit, number of orders & quantity ordered for both internet & reseller sales
by product category and ranked by sales?
*/
Select Rank() over(order by Sales desc) as Rank , *
from 
(
select sum(z.Sales) as 'Sales' , sum (z.ProductCost) as 'ProductCost', sum(z.NumberofOrders) as 'NumberofOrders' ,
       sum(z.Profit)as 'Profit', sum(z.Quantity) as 'Quantity' , ProductCategory from
(
select sum (a.SalesAmount) as 'Sales',
       sum(a.TotalProductCost) as 'ProductCost' ,
	  (sum(a.SalesAmount) - sum(a.TotalProductCost) ) as 'Profit',
	  count(distinct a.SalesOrderNumber) as 'NumberofOrders',
	  sum(a.OrderQuantity) as 'Quantity',
	  d.EnglishProductCategoryName as 'ProductCategory'
from FactInternetSales a
join DimProduct b
on a.ProductKey = b.ProductKey
join DimProductSubcategory c
on b.ProductSubcategoryKey = c.ProductSubcategoryKey
join DimProductCategory d
on d.ProductCategoryKey = c.ProductCategoryKey
group by d.EnglishProductCategoryName


UNION

select sum (a.SalesAmount) as 'Sales',
       sum(a.TotalProductCost) as 'ProductCost' ,
	  (sum(a.SalesAmount) - sum(a.TotalProductCost) ) as 'Profit',
	  count(distinct a.SalesOrderNumber) as 'NumberofOrders',
	  sum(a.OrderQuantity) as 'Quantity',
	  d.EnglishProductCategoryName as 'ProductCategory'
from FactResellerSales a
join DimProduct b
on a.ProductKey = b.ProductKey
join DimProductSubcategory c
on b.ProductSubcategoryKey = c.ProductSubcategoryKey
join DimProductCategory d
on d.ProductCategoryKey = c.ProductCategoryKey
group by d.EnglishProductCategoryName )
z
group by [ProductCategory]
)a
order by Rank;
 


/*
4. What are the sales, product costs, profit, number of orders & quantity ordered for product category Accessories
broken-down by Product Hierarchy (Category, Subcategory, Model & Product) for both internet & reseller sales?
*/
select sum(z.Sales) as 'Sales' , sum (z.ProductCost) as 'ProductCost', sum(z.NumberofOrders) as 'NumberofOrders' ,
       sum(z.Profit)as 'Profit', sum(z.Quantity) as 'Quantity' , ProductCategory , SubCategory , ProductName , ModelName
	   
	   from
(
select sum (a.SalesAmount) as 'Sales',
       sum(a.TotalProductCost) as 'ProductCost' ,
	  (sum(a.SalesAmount) - sum(a.TotalProductCost) ) as 'Profit',
	  count(distinct a.SalesOrderNumber) as 'NumberofOrders',
	  sum(a.OrderQuantity) as 'Quantity',
	  d.EnglishProductCategoryName as 'ProductCategory',
	  c.EnglishProductSubcategoryName as 'SubCategory' ,
	  b.EnglishProductName as 'ProductName' ,
	  b.ModelName          as 'ModelName'
from FactInternetSales a
join DimProduct b
on a.ProductKey = b.ProductKey
join DimProductSubcategory c
on b.ProductSubcategoryKey = c.ProductSubcategoryKey
join DimProductCategory d
on d.ProductCategoryKey = c.ProductCategoryKey
where d.EnglishProductCategoryName = 'Accessories'
group by d.EnglishProductCategoryName , c.EnglishProductSubcategoryName , b.ModelName ,b.EnglishProductName

UNION

select sum (a.SalesAmount) as 'Sales',
       sum(a.TotalProductCost) as 'ProductCost' ,
	  (sum(a.SalesAmount) - sum(a.TotalProductCost) ) as 'Profit',
	  count(distinct a.SalesOrderNumber) as 'NumberofOrders',
	  sum(a.OrderQuantity) as 'Quantity',
	  d.EnglishProductCategoryName as 'ProductCategory',
	  c.EnglishProductSubcategoryName as 'SubCategory' ,
	  b.EnglishProductName as 'ProductName' ,
	  b.ModelName          as 'ModelName'
from FactResellerSales a
join DimProduct b
on a.ProductKey = b.ProductKey
join DimProductSubcategory c
on b.ProductSubcategoryKey = c.ProductSubcategoryKey
join DimProductCategory d
on d.ProductCategoryKey = c.ProductCategoryKey
where d.EnglishProductCategoryName = 'Accessories'
group by d.EnglishProductCategoryName , c.EnglishProductSubcategoryName , b.ModelName ,b.EnglishProductName
) z
group by  ProductCategory , SubCategory , ProductName , ModelName
order by Sales desc;

/*
5. What are the sales, product costs, profit, number of orders & quantity ordered for both internet & reseller sales
by country and ranked by sales?
*/

Select Rank() over(order by Sales desc) as Rank , *
from 
(
select sum(z.Sales) as 'Sales' , 
       sum (z.ProductCost) as 'ProductCost', 
	   sum(z.NumberofOrders) as 'NumberofOrders' ,
       sum(z.Profit)as 'Profit', 
	   sum(z.Quantity) as 'Quantity' , 
	   Country 
from
(
select sum (a.SalesAmount) as 'Sales', 
       sum(a.TotalProductCost) as 'ProductCost' , 
	   (sum(a.SalesAmount) - sum(a.TotalProductCost) ) as 'Profit',
	   count(distinct a.SalesOrderNumber) as 'NumberofOrders' , 
	   sum(a.OrderQuantity) as 'Quantity',
	   b.SalesTerritoryCountry as 'Country'
from FactInternetSales a
join DimSalesTerritory b
on b.SalesTerritoryKey = a.SalesTerritoryKey
group by b.SalesTerritoryCountry

UNION

select sum (a.SalesAmount) as 'Sales',
       sum(a.TotalProductCost) as 'ProductCost' ,
	  (sum(a.SalesAmount) - sum(a.TotalProductCost) ) as 'Profit',
	  count(distinct a.SalesOrderNumber) as 'NumberofOrders',
	  sum(a.OrderQuantity) as 'Quantity',
	  b.SalesTerritoryCountry as 'Country'
from FactResellerSales a
join DimSalesTerritory b
on b.SalesTerritoryKey = a.SalesTerritoryKey
group by b.SalesTerritoryCountry
 )
z
group by Country )
z
order by Rank ;
 

 /*
6 -What are the sales, product costs, profit, number of orders & quantity ordered for France by city and ranked by
salesfor both internet & reseller sales?
*/
Select Rank() over(order by TotalSales desc) as Rank , *
from 
(
select z.City as 'City',
      sum(z.TotalSales) as 'TotalSales',
      sum(z.ProductCost) as 'ProductCost',
	  sum(z.Profit) as 'Profit',
	  sum(z.Quantity) as 'Quantity',
	  sum(z.OrderNumbers) as 'OrderNumbers'
from
(
select c.City as City,
	  sum(a.SalesAmount) as 'TotalSales',
      sum(a.TotalProductCost) as 'ProductCost',
      sum(a.SalesAmount-a.TotalProductCost) as 'Profit',
      sum(a.OrderQuantity) as 'Quantity',
      count(distinct a.SalesOrderNumber) as 'OrderNumbers'
from  FactInternetSales  a
join DimCustomer b 
on a.CustomerKey = b.CustomerKey
join DimGeography c 
on b.GeographyKey = c.GeographyKey
where c.EnglishCountryRegionName = 'France'
group by c.City

union 

select  c.City  as City,
		sum(a.SalesAmount) as 'TotalSales',
		sum(a.TotalProductCost) as 'ProductCost',
		sum(a.SalesAmount - a.TotalProductCost) as 'Profit',
		sum(a.OrderQuantity) as 'Quantity',
		count(distinct a.SalesOrderNumber) as 'OrderNumbers'
from FactResellerSales  a
join DimReseller  b 
on a.ResellerKey = b.ResellerKey
join DimGeography  c 
on b.GeographyKey = c.GeographyKey
where c.EnglishCountryRegionName = 'France'
group by c.City
)z
group by z.City )
z
order by Rank ;

/*
7. What are the top ten resellers by reseller hierarchy (business type, reseller name) ranked by sales?*/Select top 10 Rank() over(order by Sales desc) as Rank , *
from 
(select  sum(a.SalesAmount) as 'Sales', b.BusinessType , b.ResellerName from FactResellerSales ajoin DimReseller bon a.ResellerKey = b.ResellerKeygroup by b.ResellerName , b.BusinessType )zorder by Rank ;/*
8. What are the top ten (internet) customers ranked by sales?*/Select top 10 Rank() over(order by Sales desc) as Rank , *
from 
(select  sum(a.SalesAmount) as 'Sales',       CONCAT(b.LastName , ' ,' , b.FirstName) as 'CustomerName'from FactInternetSales ajoin DimCustomer bon a.CustomerKey = b.CustomerKeygroup by CONCAT(b.LastName , ' ,' , b.FirstName)) zorder by Rank ;/*
9. What are the sales, product costs, profit, number of orders & quantity ordered by Customer Occupation?*/select sum (a.SalesAmount) as 'Sales',
       sum(a.TotalProductCost) as 'ProductCost' ,
	  (sum(a.SalesAmount) - sum(a.TotalProductCost) ) as 'Profit',
	  count(distinct a.SalesOrderNumber) as 'NumberofOrders',
	  sum(a.OrderQuantity) as 'Quantity',
	  b.EnglishOccupation  as 'Occupation'
from FactInternetSales a
join DimCustomer b
on a.CustomerKey = b.CustomerKey
group by b.EnglishOccupation
order by Sales desc;


/*
10.What are the ranked sales of the sales people (employees)?*/
Select  Rank() over(order by Sales desc) as Rank , *
from 
(
select sum(a.SalesAmount) as 'Sales',  CONCAT(b.LastName , ' ,' , b.FirstName) as 'EmployeeName' 
from FactResellerSales a
join DimEmployee b
on a.EmployeeKey = b.EmployeeKey
group by CONCAT(b.LastName , ' ,' , b.FirstName)
) z
order by Rank;

/*
11.What are the sales, discount amounts (promotion discounts), profit and promotion % of sales for Reseller Sales
by Promotion Hierarchy (Category, Type & Name) – sorted descending by sales.?*/
select sum( a.SalesAmount) as 'Sales',
       Sum(a.DiscountAmount) as 'Discount',
      (sum(a.SalesAmount) - sum(a.TotalProductCost) ) as 'Profit' ,
	  b.EnglishPromotionCategory as 'Category' ,
	  b.EnglishPromotionName as 'Name' ,
	  b.EnglishPromotionType as 'Type',
	  (sum(a.DiscountAmount) / sum(a.SalesAmount) )* 100 as 'Promotion Percent'
from FactResellerSales a
join DimPromotion b
on a.PromotionKey = b.PromotionKey
group by b.EnglishPromotionCategory,  b.EnglishPromotionType , b.EnglishPromotionName
order by Sales desc ;

/*
12. What are the sales, product costs, profit, number of orders & quantity ordered by Sales Territory Hierarchy
(Group, Country, region) and ranked by sales for both internet & reseller sales?*/
Select Rank() over(order by Sales desc) as Rank , *
from 
(
select sum(z.Sales) as 'Sales' , 
       sum (z.ProductCost) as 'ProductCost', 
	   sum(z.NumberofOrders) as 'NumberofOrders' ,
       sum(z.Profit)as 'Profit', 
	   sum(z.Quantity) as 'Quantity' , 
	   z.GroupName , z.Country ,z.Region 
from
(
select  sum(a.SalesAmount) as 'Sales',
		sum(a.TotalProductCost) as 'ProductCost',
		sum(a.SalesAmount - a.TotalProductCost) as 'Profit',
		sum(a.OrderQuantity) as 'Quantity',
		count(distinct a.SalesOrderNumber) as 'NumberofOrders',
		b.SalesTerritoryGroup as 'GroupName',
		b.SalesTerritoryCountry as 'Country',
		b.SalesTerritoryRegion as 'Region'
from FactResellerSales  a
join DimSalesTerritory b
on a.SalesTerritoryKey = b.SalesTerritoryKey
group by b.SalesTerritoryGroup ,b.SalesTerritoryCountry , b.SalesTerritoryRegion 

union

select  sum(a.SalesAmount) as 'TotalSales',
		sum(a.TotalProductCost) as 'ProductCost',
		sum(a.SalesAmount - a.TotalProductCost) as 'Profit',
		sum(a.OrderQuantity) as 'Quantity',
		count(distinct a.SalesOrderNumber) as 'OrderNumbers',
		b.SalesTerritoryGroup as 'GroupName',
		b.SalesTerritoryCountry as 'Country',
		b.SalesTerritoryRegion as 'Region'
from FactInternetSales  a
join DimSalesTerritory b
on a.SalesTerritoryKey = b.SalesTerritoryKey
group by b.SalesTerritoryGroup ,b.SalesTerritoryCountry , b.SalesTerritoryRegion 

) z
group by z.GroupName , z.Country ,z.Region 
) a
order by Rank;

/*
13. What are the sales by year by sales channels (internet, reseller & total)?
*/

select sum(a.SalesAmount) as TotalSales , YEAR(a.OrderDate)  as 'yearofOrder' , 'Reseller' as 'Channel'
from FactResellerSales a
group by YEAR(a.OrderDate) 

UNION

select sum(a.SalesAmount) as TotalSales , YEAR(a.OrderDate)  as 'year' , 'Internet' as 'Channel'
from FactInternetSales a
group by YEAR(a.OrderDate)

UNION

SELECT SUM(TotalSales) as TotalSales, TOTAL.yearofOrder as 'yearofOrder', 'Total' as 'Channel' 
FROM (select sum(a.SalesAmount) as TotalSales , YEAR(a.OrderDate)  as 'yearofOrder' , 'Reseller' as 'Channel'
from FactResellerSales a
group by YEAR(a.OrderDate) 

UNION

select sum(a.SalesAmount) as TotalSales , YEAR(a.OrderDate)  as 'year' , 'Internet' as 'Channel'
from FactInternetSales a
group by YEAR(a.OrderDate)) TOTAL
group by total.yearofOrder

/*
14. What are the total sales by month (& year)?
*/

select z.Year as 'Year',
       z.Month as 'Month',
	   sum(z.TotalSales) as TotalSales from
(
select year(a.OrderDate) as 'Year',
	   month(a.OrderDate) as 'Month',
	   sum(a.SalesAmount) as TotalSales 
from FactInternetSales  a
group by year(a.OrderDate),month(a.OrderDate)

Union

select year(a.OrderDate) as 'Year',
	   month(a.OrderDate) as 'Month',
       sum(a.SalesAmount) as TotalSales 
from FactResellerSales as a
group by year(a.OrderDate),month(a.OrderDate)
)z
group by z.Month,z.Year
order by TotalSales desc