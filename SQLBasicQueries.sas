libname orion 
	"/home/u62109636/my_shared_file_links/jhshows0/STA5067/SAS Data/orion";
*******************Question 1*****************;

proc sql;
	*a;
	select * from orion.employee_payroll;
quit;

proc sql;
	*b;
	select Employee_ID, Employee_Gender, Marital_Status, Salary from 
		orion.employee_payroll;
quit;

*******************Question 2*****************;

proc sql;
	*a;
	select Employee_ID, Employee_Gender, Marital_Status, Salary, (Salary / 3) as 
		Tax from orion.employee_payroll   /*b*/;
quit;

*******************Question 3*****************;

proc sql;
	*a;
	select Employee_ID, case scan(Job_Title, -1, ' ') when "Manager" then 
		"Manager" when "Director" then "Director" when "Officer" then "Executive" 
		when "President" then "Executive" else "Other" end as Level, Salary, case 
		when calculated Level="Manager" and Salary LT 52000 then "Low" when 
		calculated Level="Manager" and Salary between 52000 and 72000 then "Medium" 
		when calculated Level="Manager" and Salary GT 72000 then "High" when 
		calculated Level="Director" and Salary < 108000 then "Low" when calculated 
		Level="Director" and Salary >=108000 and Salary <=135000 then "Medium" when 
		calculated Level="Director" and Salary > 135000 then "High" when calculated 
		Level="Executive" and Salary < 240000 then "Low" when calculated 
		Level="Executive" and 240000 <=Salary and Salary <=300000 then "Medium" when 
		calculated Level="Executive" and Salary > 300000 then "High" ELSE " " end as 
		Salary_Range from orion.staff;
quit;

*******************Question 4*****************;

proc sql;
	*a;
	title "Cities where Employees Live";
	select distinct city         /*b*/
	from orion.employee_addresses        /*c*/;
quit;

proc print data=orion.employee_donations;
run;

*******************Question 5*****************;

proc sql;
	/*a*/
	title "Donations Exceeding $90.00";
	select Employee_ID, recipients, sum(Qtr1, Qtr2, Qtr3Qtr4) as Total from 
		orion.employee_donations          /*b*/
		where calculated Total > 90.00         /*c*/;
quit;
