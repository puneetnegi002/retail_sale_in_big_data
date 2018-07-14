# retail_sale_in_big_data
Analysis Of Retail sale  using Big data  and visualise it using tableau


Project Setup: 
1.	Create the below folders in HDFS:
 /user/cloudera/retail
 /user/cloudera/retail/retailsalesraw
 /user/cloudera/retail/retailsalesclean
 /user/cloudera/retail/georevenue 
/user/admin/retail/marketbaskets 
2. Load the raw data to retailsalesraw folder in HDFS
 3. Create “ETL.pig” with below functionalities 
-- Loading raw data
 -- Cleansing File 
a. Filtering out the header
 b. Make the timestamp format consumable by Hive by adding the seconds field (Hint: CONCAT(InvoiceDate,':00'))
 c. Add a column with the Total Price for a line item (Quantity * Unit Price)
 -- Storing Cleansed File into HDFS (/home/cloudera/retail/retailsalesclean) 
-- Generate Overall Sales Aggregate and Sales for top 10 countries (“You can call the file as Top10GeoRevenue”) 
-- STORE Top10GeoRevenue file into HDFS ('/user/admin/retail/georevenue’)

4. Create a “analysis_hive.hql” file for performing analysis under analysis section
 5. Create  a “MarketBaskets.pig” code for data preparation for the market basket analysis using any predictive modeling software like spark MLLib
 -- Load the raw data 
-- Remove observations with InvoiceNo is Null
 -- Remove observations with stock code is null
 -- Remove observations with stock code is “DOT” or “POST “or “Bank” or “M” or  “ ”
 -- Create a new variable “Stockcat” from extracting first 4 digits of stock code
 -- Remove observations with Stock cat is 8509 
-- Remove duplicates 
-- Remove the baskets with basket size >10 and <1 where basketsize is number of items in a transaction
