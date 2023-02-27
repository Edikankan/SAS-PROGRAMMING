libname orion 
	"/home/u62109636/my_shared_file_links/jhshows0/STA5067/SAS Data/orion";
******************Question 1*****************;
/*Creating and Using a View to Provide Consolidated Information*/
proc sql;
	create view T_Shirts as select pd.Product_ID, pd.Supplier_Name, Product_Name, 
		Unit_Sales_Price as price "Retail Price" from orion.Product_Dim as pd, 
		orion.Price_list as pl where pd.Product_ID=pl.Product_ID and 
		lowcase(Product_Name) like "%t-shirt%";
quit;

proc sql;
	title"T-Shirts";
	select * from work.T_Shirts order by Supplier_Name, Product_ID;
quit;

title;

proc sql;
	title"T-Shirts with price less than $20.00";
	select Product_ID, Product_Name, price from T_Shirts where price lt 20 order 
		by price;
quit;

title;

proc print data=orion.price_list;
run;

******************Question 2*****************;
/*Creating and Using a View That Updates Itself over Time*/
proc sql;
	create view Current_Catalog as select pd.*, round(unit_Sales_Price * 
		(Factor**(year(Today())-year(Start_Date))), .01) as Price 
		"Current Retail Price" format=dollar13.2 from orion.product_dim as pd inner 
		join orion.Price_list as pl on pd.product_id=pl.product_id;
	select * from Current_Catalog;
quit;

proc sql;
	title"Current Roller Skate Retail Prices";
	select Supplier_Name, Product_Name, Price from Current_Catalog where 
		lowcase(Product_Name) like '%roller skate%' order by 1, 3;
quit;

title;

proc sql;
	title"Products With More Than $5.00 increase";
	select cc.Product_Name, pl.unit_sales_price, cc.price, 
		(price - unit_sales_price) as Increase format=dollar13.2 from Current_Catalog 
		as cc, orion.price_list as pl where cc.product_id=pl.product_id and 
		calculated increase gt 5 order by Increase desc;
quit;

title;
******************Question 3*****************;
/*Creating a Table and Adding Data Using a Query*/
proc sql;
	create table Employees as select ea.Employee_Id, ep.Employee_Hire_Date 
		FORMAT=DATE9. as Hire_Date, ep.Salary format=COMMA10.2, ep.Birth_Date 
		format=DATE11., ep.Employee_Gender as Gender, ea.Country, ea.City from 
		orion.employee_addresses as ea, orion.employee_payroll as ep where 
		ea.employee_id=ep.employee_id and Employee_Term_Date is missing order by 2, 
		Salary desc;
	select * from Employees;
quit;

proc sql;
	select * from Employees where Gender="F" and Salary gt 75000;
quit;

proc contents data=orion.sales;
run;

******************Question 4*****************;
/*Creating a Table and Inserting Data Using a Complex Query*/
proc sql;
	create table Direct_Compensation 
	(Employee_ID num format=z12. , Name char(20), Level char(10), Salary float, 
		Commission float, Direct_Compensation float);
	insert into Direct_Compensation
		(Employee_ID, Name, Level, Salary, Commission, Direct_Compensation) select 
		s.Employee_ID, s.first_Name|| " " ||s.last_name as Name, s.job_title as 
		Level, s.Salary, (0.15 * sum(of.total_retail_price)) as Commission, 
		(s.salary + (0.15 * sum(of.total_retail_price))) as Direct_Compensation from 
		orion.order_fact as of, orion.sales as s where of.employee_id=s.employee_id 
		and job_title contains ("I, II, III, IV") and year(of.order_date) eq 2007 
		group by s.employee_id, s.first_name;
	select * from direct_compensation;
quit;
