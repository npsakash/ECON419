/*Importing Data*/
/* Specifying a library name */
libname f "";
run;

/* Importing data */

/* Method 1:  Use the SAS wizard to import Excel, CSV, Access,
  DBA, etc. data files */

/* Method 2:  Use code to import Excel, CSV, Access, etc. data files */

/* Example 1: Importing Excel files */
PROC IMPORT OUT= F.elemapi 
            DATAFILE= "C:\Users\npsakash\Desktop\f\lab2\elemapi.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN; 

/*elemapi2*/
PROC IMPORT OUT= F.elemapi2 
            DATAFILE= "C:\Users\npsakash\Desktop\f\lab2\elemapi2.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN; 

/*Import Earnings and Height*/
PROC IMPORT OUT= F.earningsHeight 
            DATAFILE= "C:\Users\npsakash\Desktop\f\lab2\Earnings_and_Height.xls" 
            DBMS=xls REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN; 

proc print data=f.earningsHeight(obs=5);
run;

/*Basic data statistics*/
/*i*/
proc means data=f.earningsHeight;
var height;
run;

/*Average height = 66.79*/

/*ii*/
proc means data=f.earningsHeight;
where height<67;
var earnings;
run;

/*Average earnings for those less than 67" = $45,071.62*/

/*iii*/
proc means data=f.earningsHeight;
where height>67;
var earnings;
run;

/*Average earnings for those greater than 67" = $51,418.94*/

/*iv*/
proc sgplot data=f.earningsHeight;
scatter x = height y = earnings;
run;
