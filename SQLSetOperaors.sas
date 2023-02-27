libname orion 
	"/home/u62109636/my_shared_file_links/jhshows0/STA5067/SAS Data/orion";
******************Question 1*****************;
/*Using the INTERSECT Operator*/
proc sql;
	title"Customer IDs of Customers who placed orders";
	select customer_id from orion.order_fact intersect select customer_id from 
		orion.customer;
quit;

******************Question 2*****************;
/*Using the EXCEPT Operator to Count Rows*/
proc sql;
	title"Total Employees With No Donations";
	select count(*) as Total_Employees from (select employee_id from 
		orion.employee_organization except select employee_id from 
		orion.employee_donations);
quit;

title;
******************Question 3*****************;
/*Using the INTERSECT Operator to Count Rows*/
proc sql;
	title"# of Customers With Orders";
	select count(*) as Total_Customers from (select customer_id from 
		orion.order_fact intersect select customer_id from orion.customer);
quit;

title;
******************Question 4*****************;
/*USing the EXCEPT Operator with a Subquery*/
proc sql;
	title"Reps With no Sales in 2007";
	select employee_id, employee_name from orion.employee_addresses where 
		employee_id in
			(select employee_id from orion.sales where job_title contains "Rep" 
		except all select employee_id from orion.order_fact where year(order_date) eq 
		2007);
quit;

title;
******************Question 5*****************;
/*Using the INTERSECT Operator with a subquery*/
proc sql number;
	title"Name and ID of Customers Who Placed Orders";
	select customer_id, customer_name from orion.customer where customer_id in
			(select customer_id from orion.order_fact intersect select customer_id 
		from orion.customer);
quit;

title;
******************Question 6*****************;
/*Using the UNION Operator*/
proc sql;
	title"Payroll Report for Sales Representatives";
	select "Total Paid to ALL Female Sales Representatives", SUM(Salary), count(*) 
		from orion.sales where gender="F" and job_title contains "Rep" union select 
		"Total Paid to ALL Male Sales Representatives", SUM(Salary), count(*) from 
		orion.sales where gender="M" and job_title contains "Rep";
quit;

title;
******************Question 7*****************;
/*Using the OUTER UNION Operator with the CORR Keyword*/
proc sql;
	title"Sales Data for 1st and 2nd Qtrs 2007";
	select * from orion.qtr1_2007 outer union corr select * from orion.qtr2_2007;
quit;

title;
******************Question 8*****************;
/*Comparing UNION and OUTER UNION Operators*/
proc sql;
	title"Comparing UNION and OUTER UNION";
	select * from orion.qtr1_2007 union select * from orion.qtr2_2007;
	select * from orion.qtr1_2007 outer union select * from orion.qtr2_2007;
quit;

title;

/* WE NOTICE THE UNION OPERATOR OVVERLAYS THE COLUMNS WHILE THE OUTER UNION DOES NOT.
*/
