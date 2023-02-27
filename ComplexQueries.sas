libname orion 
	"/home/u62109636/my_shared_file_links/jhshows0/STA5067/SAS Data/orion";
******************Question 1*****************;
/*Using In-Line Views*/
title "2007 Sales Force Sales Statistics";
title1 "For Employees With 200.00 or More in Sales";

proc sql;
	select country, first_name, last_name, value_sold, Orders, Avg_Order 
		format=comma6.2 from(select sum(Total_retail_price) as Value_sold, 
		employee_id, count(*) as Orders, sum(Total_retail_price)/count(*) as 
		Avg_Order from orion.order_fact as of where year(order_date)=2007 group by 
		employee_id) as v, orion.sales as s where v.employee_id=s.employee_id and 
		value_sold ge 200 group by country, first_name, last_name order by country, 
		Value_sold desc, Orders desc;
quit;

title;
title "2007 Sales Summary by Country";

proc sql;
	select country, max(Value_Sold) format=comma7.2 "Max Value Sold", max(Orders) 
		format=comma6.2 "Max Orders", max(Avg_order) format=comma6.2 "Max Average", 
		min(Avg_order) format=comma6.2 "Min Average" from(select country, first_name, 
		last_name, value_sold, Orders, Avg_Order from(select sum(Total_retail_price) 
		as Value_sold, employee_id, count(*) as Orders, 
		sum(Total_retail_price)/count(*) as Avg_Order from orion.order_fact as of 
		where year(order_date)=2007 group by employee_id) as v, orion.sales as s 
		where v.employee_id=s.employee_id and value_sold ge 200
		/*group by country*/) group by country;
quit;

/*
proc print data=orion.order_fact;title"order fact";run;title;
proc print data=orion.sales;title"sales";run;title;
proc print data=orion.employee_addresses;title"addresses";run;title;
proc print data=orion.employee_organization;title"organization";run;title;*/
******************Question 2*****************;
/*Building Complex Queries with In-Line Views*/
title "Employee Salaries as a Percent of Department Total";

proc sql;
	select department, sum(salary) as Dept_Salary_Total from 
		orion.employee_payroll as ep, orion.employee_organization as eo where 
		ep.employee_id=eo.employee_id group by 1 order by 1;
quit;

proc sql;
	select ea.employee_id, ea.employee_name, eo.department from 
		orion.employee_addresses as ea, orion.employee_organization as eo where 
		ea.employee_id=eo.employee_id order by 2;
quit;

proc sql;
	select i2.department, i2.employee_name, ep.salary format=comma10.2, (ep.salary 
		/ i1.Dept_Salary_Total) as Percent format=percent14.1 from 
			(select department, sum(salary) as Dept_Salary_Total from 
		orion.employee_payroll as ep, orion.employee_organization as eo where 
		ep.employee_id=eo.employee_id group by 1)as i1 inner join 				
				(select ea.employee_id, ea.employee_name, eo.department from 
		orion.employee_addresses as ea, orion.employee_organization as eo where 
		ea.employee_id=eo.employee_id)as i2 on i1.department=i2.department inner join 
		orion.employee_payroll as ep on i2.employee_id=ep.employee_id order by 1, 4 
		desc;
quit;

title;

/*proc sql;
select scan(employee_name,-1,',') as first, scan(employee_name,1,',') as last
from orion.employee_addresses
;
quit;first||last as Manager;
proc sql;
select scan(employee_name,-1,',') || scan(employee_name,1,',') as name, ea.employee_id, eo.manager_id
from orion.employee_addresses as ea
join orion.employee_organization as eo
on ea.employee_id = eo.manager_id
order by name desc
;
quit;*/
******************Question 3*****************;
/*Building a Complex Query Using a Multi-Way Join*/
title "2007 Total Sales Figures";

proc sql;
	select scan(manager, -1, ',') || scan(manager, 1, ',') as Manager, 
		scan(employee, -1, ',') || scan(employee, 1, ',') as Employee, Total_Sales 
		format=comma7.2 from 
			(select employee_name as Employee, employee_id, country from 
		orion.employee_addresses as ea) as v1, (select sum(total_retail_price) as 
		Total_Sales, employee_id from orion.order_fact as of where 
		year(order_date)=2007 group by employee_id) as v2, (select Employee_Name as 
		Manager, eo.employee_id from orion.Employee_Addresses as ea, 
		orion.employee_organization as eo where ea.Employee_ID=eo.Manager_ID) as v3 
		where v1.employee_id=v2.employee_id and v1.employee_id=v3.employee_id group 
		by 1 order by 1 desc, 3 desc, country="AU";
quit;

title;
