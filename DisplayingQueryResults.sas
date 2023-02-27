libname orion 
	"/home/u62109636/my_shared_file_links/jhshows0/STA5067/SAS Data/orion";
*******************Question 1*****************;
/*Enhancing Output with Titles and Formats*/
proc sql;
	title"Single Male Employee Salaries";
	select Employee_ID, Salary format=comma10.2, (Salary/3) as Tax 
		format=COMMA10.2 from orion.employee_payroll where (Employee_Gender="M" and 
		Marital_Status="S") and Employee_Term_Date is not missing order by Salary 
		desc;
quit;

title;
*******************Question 2*****************;
/*Using Formats to Limit the Width of Columns in the Output*/
proc sql;
	title"Australian Clothing Products";
	select Supplier_name label="Clothing Supplier's Name", product_group 
		"Clothing Group", product_name "Name of Product" from orion.product_dim where 
		product_category="Clothes" and supplier_country="AU" order by Product_name;
quit;

title;
*******************Question 3*****************;
/*Enhancing Output with Multiple Techniques*/
proc sql;
	title"U.S. customers older than 50 years on 31DEC2007";
	select put(customer_ID, z6.) as customer_ID, 
		(Customer_LastName|| " " || Customer_FirstName) as customer_name, gender as 
		customer_gender, int(('31DEC2007'd-Birth_Date)/365.25) as customer_age from 
		orion.customer where (country="US" and calculated customer_age > 50) order by 
		4 desc, Customer_LastName, Customer_FirstName;
quit;

title;
*******************Question 4*****************;
/*summarizing Data*/
proc sql;
	title"Cities Where Employees Live";
	select city, count(*) from orion.employee_addresses group by City order by 
		City;
quit;

title;
*******************Question 5*****************;
/*Using SAS Functions*/
proc sql;
	title"Age at Employment";
	select employee_id, birth_date format=MMDDYY10., employee_hire_date 
		format=MMDDYY10., int((Employee_Hire_Date - Birth_Date)/365.25) as Age from 
		orion.employee_payroll;
quit;

title;
*******************Question 6*****************;
/*Summarizing Data*/
proc sql;
	title"Customer Demographics: Gender by Country";
	select country, count(*) as TotalCustomers, sum(gender="M") as TotalMale, 
		sum(gender="F") as TotalFemale, calculated TotalMale / calculated 
		TotalCustomers "Percent Male" format=percent6.2 from orion.customer group by 
		country order by 5, country;
quit;

title;
*******************Question 7*****************;
/*Summarizing Data in Groups*/
proc sql;
	title"Countries with more Female than Male Customers";
	select country as Country, sum(gender="M") 'Male Customers', sum(gender="F") 
		'Female Customers' from orion.customer group by country 
		having ((sum(gender="F")) > (sum(gender="M") )) order by 3 desc;
quit;

title;
