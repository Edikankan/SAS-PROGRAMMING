libname orion 
	"/home/u62109636/my_shared_file_links/jhshows0/STA5067/SAS Data/orion";
*******************Question 1*****************;
/*Using Subquieries*/
proc sql;
	select avg(quantity) as MeanQuantity from orion.order_fact;
quit;

proc sql;
	title"Employees whose Average Quantity Items Sold";
	title2"Exceeds the Company’s Average Items Sold";
	select Employee_ID, avg(Quantity) as MeanQuantity format=comma4.2 from 
		orion.order_fact group by Employee_ID having avg(Quantity) >
			(select avg(quantity) as MeanQuantity from orion.order_fact);
quit;

title;
*******************Question 2*****************;
/Using a Noncorrelated Subquery*/
proc sql;
	title"Employee IDs for February Anniversaries";
	select Employee_ID from orion.employee_payroll where 
		month(Employee_Hire_Date)=2;
quit;

title;

proc sql;
	title"Employees with February Anniversaries";
	select Employee_ID, scan(Employee_Name, -1) "First Name" length=15, 
		scan(Employee_Name, 1) "Last Name" length=15 from orion.employee_addresses 
		where employee_id in
			(select Employee_ID from orion.employee_payroll where 
		month(Employee_Hire_Date)=2) order by 3;
quit;

title;
*******************Question 3*****************;
/*Creating subqueries Using the ALL Keyword*/
proc sql;
	title"Level I or II Purchasing Agents";
	title2"Who are older than ALL Purchasing Agent IIIs";
	select Employee_ID, Job_Title, Birth_Date, 
		int(('24NOV2007'D - Birth_Date)/365.25) as Age from orion.staff where 
		Job_Title in ("Purchasing Agent I", "Purchasing Agent II") and 
		birth_date < all
			(select birth_date from orion.staff where 
		Job_Title="Purchasing Agent III");
quit;

title;
*******************Question 4*****************;
/*Using Nested Subqueries*/
proc sql;
	title"Employee With The Highest Total Sales";
	select Employee_ID, sum(Total_retail_price * Quantity) as Total_Sales 
		format=dollar9.2 from orion.order_fact as of group by 1 having Employee_ID 
		in 
			(select employee_id from orion.order_fact where employee_id ne 99999999) 
		and calculated Total_Sales > all
					(select (Total_retail_price*quantity) from orion.order_fact);
quit;

title;
**********************OTHER WAY****************;

proc sql outobs=1;
	select employee_id, sum(Total_retail_price * Quantity) as Total_Sales 
		format=dollar9.2 from orion.order_fact as of where employee_id ne 
		99999999 /*ONE*/
		group by Employee_ID order by 2 desc;
quit;

proc sql;
	title"Employee With The Highest Total Sales";
	select Employee_ID, Employee_name from orion.employee_addresses as ea, 
		orion.order_fact as of where 8446.70=(select sum(Total_retail_price * 
		Quantity) from orion.order_fact where ea.employee_id=of.employee_id) 
		/*where  exists
		(select *
		from orion.order_fact as of
		where ea.employee_id = of.employee_id)
		and
		sum(Total_retail_price * Quantity) > all
		(select (Total_retail_price*quantity)
		from orion.order_fact) */;
quit;

proc sql;
	title "Name of the Employee With the Highest Total Sales";
	select employee_id, employee_name from orion.employee_addresses having 
		employee_id ne 99999999 and employee_id in (select employee_id from 
		orion.order_fact group by employee_id having sum(total_retail_price*quantity) 
		>=all (select sum(total_retail_price*quantity) from orion.order_fact group by 
		employee_id having employee_id ne 99999999));
quit;

proc sql;
	select lastname, firstname from train.flightattendants as a where not exists
  (select * from train.flightschedule as s where a.empid=s.empid);
quit;

proc print data=orion.employee_addresses;
run;

proc sql;
	title "Name of the Employee With the Highest Total Sales";
	select employee_id, employee_name from orion.employee_addresses having 
		employee_id ne 99999999 and employee_id in (select employee_id from 
		orion.order_fact group by employee_id having sum(total_retail_price*quantity) 
		>=all (select sum(total_retail_price*quantity) from orion.order_fact group by 
		employee_id having employee_id ne 99999999));
quit;

proc sql;
	select employee_id, employee_name from orion.employee_addresses 
		where (Total_retail_price * Quantity) eq 8446.70) 
		/*select sum(Total_retail_price * Quantity) as Total_Sales
		format=dollar9.2
		from orion.order_fact
		group by Employee_ID
		having Employee_ID in
		(select employee_id
		from orion.order_fact
		where employee_id ne 99999999)
		and calculated Total_Sales > all
		(select (Total_retail_price*quantity)
		from orion.order_fact)
		where employee_id in
		(select employee_id
		from orion.order_fact*/;
quit;

title "Employee With the Highest Total Sales";
select o.employee_id, employee_name, sum(total_retail_price*quantity) format 
	dollar10.2 as Total_Sales from orion.order_fact as o, orion.employee_addresses 
	as a where o.employee_id=a.employee_id group by o.employee_id having 
	o.employee_id in (select employee_id from orion.employee_addresses) and 
	calculated total_sales >=all (select sum(total_retail_price*quantity) from 
	orion.order_fact group by employee_id having employee_id ne 99999999);
quit;
title;
*******************Question 5*****************;
/*Creating a Simple Correlated Subquery*/
proc sql;
	title"Australian Employees' Birth Months";
	select employee_id, month(Birth_date) as BirthMonth from 
		orion.employee_payroll as ep where "AU"=(select Country from 
		orion.employee_addresses as ea where ep.Employee_ID=ea.Employee_ID) order by 
		2;
quit;

title;
*******************Question 6*****************;
/*Using a Correlated Subquery*/
proc sql;
	title"Employees With Donations > 0.002 Of Their Salary";
	select employee_id, employee_gender, marital_status from 
		orion.employee_payroll where employee_id in  
			(select employee_id from orion.employee_donations where sum(qtr1, qtr2, 
		qtr3, qtr4) / salary > 0.002);
quit;
