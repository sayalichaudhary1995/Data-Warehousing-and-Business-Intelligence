/*
1. Total sales 
*/

select sum(Total) as 'Total Sales'  
  from invoice 


/*
2. Total sales by country – ranked 
*/

Select Rank() over(order by Total_Sales desc) as Rank , *
from 
(
select sum(Total)  as 'Total_Sales'  , Customer.Country
from   invoice 
join   Customer
  on   Invoice.CustomerId = Customer.CustomerId
group by Customer.Country
)a
order by Rank;

/*
3. Total sales by country, state & city
*/

select sum(Total)  as 'Total_Sales'  , Customer.Country , Customer.State, Customer.City
from   invoice 
join   Customer
  on   Invoice.CustomerId = Customer.CustomerId
group by Customer.Country , Customer.State, Customer.City
order by Total_Sales desc;


/*
4. Total sales by customer – ranked
*/
Select Rank() over(order by Total_Sales desc) as Rank , *
from 
(
select sum(Total)  as 'Total_Sales'  ,  CONCAT(Customer.LastName, ', ' , Customer.FirstName) as 'customer_name'
from   invoice 
join   Customer
  on   Invoice.CustomerId = Customer.CustomerId
group by CONCAT(Customer.LastName, ', ' , Customer.FirstName)
)a
order by Rank;

/*
5. Total sales by artist – ranked
*/
Select Rank() over(order by Total_Sales desc) as Rank , *
from 
(
select sum(InvoiceLine.Quantity * InvoiceLine.UnitPrice) as 'Total_sales' , Artist.Name
from   InvoiceLine
join   Track
  on   InvoiceLine.TrackId = Track.TrackId
join   Album
  on   Album.AlbumId = Track.AlbumId
join   Artist
  on   Album.ArtistId = Artist.ArtistId
group by Artist.Name
)a
order by Rank;

/*
6. Total sales by albums
*/


select sum(InvoiceLine.Quantity * InvoiceLine.UnitPrice) as 'Total_sales' , Album.Title
from   InvoiceLine
join   Track
  on   InvoiceLine.TrackId = Track.TrackId
join   Album
  on   Album.AlbumId = Track.AlbumId
group by Album.Title
order by Total_sales desc ;

/*
7 . Total sales by sales person (employee)
*/
select sum(Total)  as 'Total_Sales'  , CONCAT(Employee.LastName , ',' , Employee.FirstName) as 'FullName'
from   invoice 
join   Customer
on Invoice.CustomerId = Customer.CustomerId
join Employee
on Customer.SupportRepId = Employee.EmployeeId
group by CONCAT(Employee.LastName , ',' , Employee.FirstName)
order by 'Total_Sales' desc ;

/*
 8. Total tracks bought and total revenue by media type
*/
select sum(InvoiceLine.Quantity * InvoiceLine.UnitPrice) as 'Total_sales' , MediaType.Name , count(Track.TrackId) as 'Number of Tracks'
from   InvoiceLine
join   Track
  on   InvoiceLine.TrackId = Track.TrackId
join   MediaType
  on   MediaType.MediaTypeId = Track.MediaTypeId
group by MediaType.Name
order by Total_sales desc ;

/*
9.Total Sales by Customer
*/

select sum(Total)  as 'Total_Sales'  , 
       CONCAT(Customer.LastName , ',' , Customer.FirstName) as 'FullName'
from   invoice
join   Customer
on Invoice.CustomerId = Customer.CustomerId
group by CONCAT(Customer.LastName , ',' , Customer.FirstName)
order by 'Total_Sales' desc ;


/*
10.Total Sales by Genre
*/

select sum(InvoiceLine.Quantity * InvoiceLine.UnitPrice) as 'Total_sales' , Genre.Name
from   InvoiceLine
join   Track
  on   InvoiceLine.TrackId = Track.TrackId
join   Genre
  on   Track.GenreId = Genre.GenreId
group by Genre.Name
order by Total_sales desc ;