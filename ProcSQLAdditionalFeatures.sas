%let path=/home/u62109636/my_shared_file_links/jhshows0/STA5067/SAS Data;
libname orion "&path/orion";
******************Question 1*****************;
/*Creating and Using Macro Variables*/
proc sql;
	/*a*/
	title "Highest Salary in Employee_payroll";
	select max(Salary) from orion.employee_payroll;
quit;

title;
%let DataSet = Employee_payroll;

/*b*/
%let VariableName = Salary;
%put &DataSet;
%put &VariableName;

proc sql;
	/*c*/
	title "Highest &VariableName in &DataSet";
	select max(&VariableName) from orion.&DataSet;
quit;

title;
%let DataSet = Price_List;

/*d*/
%let VariableName = Unit_Sales_Price;
******************Question 2*****************;
/*Creating a Macro Variable from an SQL Query*/
proc sql;
	/*a*/
	title"2007 Purchases by Country";
	select Country, SUM(Total_Retail_Price) format=dollar10.2 as Purchases from 
		orion.customer as c, orion.order_fact as of where 
		c.customer_id=of.customer_id and year(Order_Date) eq 2007 group by 1 order by 
		2 desc;
quit;

proc sql;
	/*b*/
	title "2007 US Customer Purchases";
	title2 "Total US Purchases: $10,655.97";
	select Customer_Name, sum(Total_Retail_Price) format=dollar10.2 as Purchases 
		from orion.customer as c, orion.order_fact as of where 
		c.Customer_ID=of.Customer_ID and year(Order_Date)=2007 and Country="US" group 
		by 1 order by 2 desc;
quit;

title;

proc sql;
	/*c(1)*/
	title"2007 Purchases by Country";
	select Country, SUM(Total_Retail_Price) format=dollar10.2 as Purchases 
		into:Country, :Country_Purchases from orion.customer as c, orion.order_fact 
		as of where c.customer_id=of.customer_id and year(Order_Date) eq 2007 group 
		by 1 order by 2 desc;
quit;

proc sql;
	/*c(2)*/
	title "2007 &Country Customer Purchases";
	title2 "Total &Country Purchases: &Country_Purchases";
	select Customer_Name, sum(Total_Retail_Price) format=dollar10.2 as Purchases 
		from orion.customer as c, orion.order_fact as of where 
		c.Customer_ID=of.Customer_ID and year(Order_Date)=2007 and Country="&Country" 
		group by 1 order by 2 desc;
quit;

title;

proc sql;
	/*d*/
	title"2007 Purchases by Country";
	select Country, SUM(Total_Retail_Price) format=dollar10.2 as Purchases 
		into:Country, :Country_Purchases from orion.customer as c, orion.order_fact 
		as of where c.customer_id=of.customer_id and year(Order_Date) eq 2007 group 
		by 1 order by 2;
quit;

title;

proc sql;
	title "2007 &Country Customer Purchases";
	title2 "Total &Country Purchases: &Country_Purchases";
	select Customer_Name, sum(Total_Retail_Price) format=dollar10.2 as Purchases 
		from orion.customer as c, orion.order_fact as of where 
		c.Customer_ID=of.Customer_ID and year(Order_Date)=2007 and Country="&Country" 
		group by 1 order by 2 desc;
quit;

title;
