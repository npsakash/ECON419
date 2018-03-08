libname f"";
run;

/* Linear Test */

proc reg data=f.lawsch85;
model lsalary = lsat gpa llibvol lcost rank;
run;

/*
i.
Ho: rank = 0
Ha: rank != 0

rank p-value = <0.0001
reject Ho. so rank does have an effect on starting median salary
*/

/*
ii.
Ho: lsat=gpa=0
Ha: lsat!=gpa!=0
*/
proc reg data=f.lawsch85;
model lsalary = lsat gpa llibvol lcost rank;
test lsat=gpa=0;
run;
/*
Numerator P-value < 0.0001
Reject null 
*/

/*
iii
add clsize faculty
*/
proc reg data=f.lawsch85;
model lsalary = lsat gpa llibvol lcost rank clsize faculty;
run;


