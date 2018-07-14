
##retailtable
create external table if not exists onlineretail(InvoiceNo bigint,StockCode string,
Description string,Quantity int,InvoiceDate timestamp,UnitPrice float,CustomerId int,Country String,TotalPrice float) row format delimited fields terminated by '\t'
location '/user/cloudera/retail/retailsalesclean/retail';

--load data inpath 'user/cloudera/retail/retalsalesclean/c.pigout' into table onlineretail;

##Revenue Aggregate By Country for top 5 countries

CREATE VIEW Georevenue as select Country,sum(TotalPrice) as Revenue from 
onlineretail group by country order by Revenue desc limit 10; 


##salesmetrics
create table salesmatrics as WITH onl AS (Select country, customerid, invoiceno, count(distinct Stockcode) as NumItems,
sum(totalprice) as Total from onlineretail group by country,invoiceno,customerid)
select Country, count(distinct customerid) as NumCustomers, count(distinct invoiceno) as 
NumTransactions,avg(NumItems) as AvgNumItems,min(Total) as
MinAmtperCustomer,max(Total) as MaxAmtperCustomer,
avg(Total) as AvgAmtperCustomer,stddev_pop(Total) as 
StdDevAmtperCustomer from onl group by Country order by NumCustomers desc limit 5

##dailysalesactivity_posix_day_of_the_year

create table daily_sales_by_year as with ds as (select dayofyear(Invoicedate) as DYear,Invoiceno, totalprice from onlineretail where totalprice > 0 and Invoicedate > '2010-11-31' and Invoicedate < '2011-12-01')
select DYear, count(distinct Invoiceno) as NumVisits, ceil(sum(totalprice)) as TotalAmt from ds group by DYear order by DYear

##hoursale
create table hoursale as with hs as (select hour(Invoicedate) as hours,Invoiceno, totalprice from onlineretail where totalprice > 0)
select hours, count(distinct Invoiceno) as NumVisits, ceil(sum(totalprice)) as TotalAmt from hs group by hours order by hours

##top20itemsold
create table top20item select Description, count(Stockcode) as ItemFrequency from retailsales where totalprice > 0  group by Description order by ItemFrequency desc limit 20



##customerlifetimevalue
create table customerltv as with cltv as (select customerid, count(distinct invoiceno) as numtransactions, ceil(sum(totalprice)/1000)*1000 as customerlifetimevalue from onlineretail where customerid is not null and totalprice > 0 group by customerid)
select  customerlifetimeValue, count(customerlifetimevalue) as numcustomers from cltv group by customerlifetimevalue order by customerlifetimevalue asc

##basketdistribution
create table basketdist as with bkt as (select invoiceno, count(distinct Stockcode) as numitems from onlineretail group by invoiceno)
select numitems, count(numitems) as countnumitems from bkt group by numitems order by numitems asc

