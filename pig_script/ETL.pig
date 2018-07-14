a = load 'retail/retailsalesraw/OnlineRetail.txt' AS(InvoiceNo:int,StockCode:chararray,Description:chararray,Quantity:int,InvoiceDate:chararray,UnitPrice:float,CustomerID:chararray,Country:chararray);

b= filter b by $0>1;

c= foreach b generate InvoiceNo,StockCode,Description,Quantity,CONCAT(InvoiceDate,':00'),UnitPrice,CustomerID,Country,(Quantity*UnitPrice) as TotalPrice;

store c into 'retail/retailsalesclean/'

d = group c by Country;
e = foreach d generate group,SUM(c.TotalPrice) as totalrevenue;
f= ORDER e by totalrevenue DESC;
f= limit ord 10;
store f into 'retail/georevenue/top10georevenue';