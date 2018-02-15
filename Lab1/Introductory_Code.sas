/*Importing Data*/
/* Specifying a library name */
libname f "";
run;

/* Importing data */

/* Method 1:  Use the SAS wizard to import Excel, CSV, Access,
  DBA, etc. data files */

/* Method 2:  Use code to import Excel, CSV, Access, etc. data files */

/* Example 1: Importing Excel files */
PROC IMPORT OUT= work.Fertility1 
            DATAFILE= "C:\Users\Neal\Documents\CofC\2018\ECON 419\SASUniversityEdition\myfolders\f\fertil2.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN; 

/* The OUT=, defines the location where the SAS file is saved.
The DATAFILE=, defines the location where the CSV file is saved.
The DBMS=, defines the type of file you are importing; in this case it was a CSV.
The REPLACE command informs SAS to replace the CSV file in the case it already existed.
The GETNAMES=YES instructs SAS to use the variable�s names that appear in the first row of the CSV file.  If the CSV file does not have variable�s names, set this option equal to NO; in this case, SAS will generate default names for each column.  The default setting is YES.
The DATAROW=2, instructs SAS to start reading data from row number 2, in the external file.

Other Options with the proc import are as follows:

MIXED=NO, instructs SAS to avoid converting numerical values to character values; this is the default option.
SCANTEXT=YES instructs SAS to scan the length of the data and use the length of the longest string data that it finds as the SAS column width
USEDATE=YES instructs SAS to use the DATE.format for any data/time columns.  If it is set to NO, SAS uses the DATETIME.formate instead. */
 

/* Creating a data set by entering values */
/* The variable farm in the INPUT statement is followed by a dollar sign ($) indicating that this is a character variable. 
Without specific instructions, SAS assumes that variables are numeric. If it then encounters a character, it will assign a 
missing value (.) to the variable for that observation. */

data f.dt1;
input record year farm $ acres chickens $2.;
label record="Farm Number"
  year="Year"
  farm="Farm Name"
  acres="Planted Acres"
  chickens="Number of chickens"
;
datalines;
2 1999 HappyFam 554 44
1 1999 MmDonuts 334 32
3 1999 NoRecord . .
5 1999 TinyCow 1234 56
8 1999 Wheater 442 12
14 1999 Deere 994 72
1 2000 MmDonuts 324 41
2 2000 HappyFam 604 35
3 2000 NoRecord . .
5 2000 TinyCow 1532 76
8 2000 Wheater 204 9
14 2000 Deere 763 63
;
run;

proc contents data=f.dt1;
run;


/* Basic data manipulation */
/* a. Sorting data */
/* 1. Sort data by a variable in ascending order (lowest is first) */
/* Example: Sort farms such that those with lowest acreage are first */

proc sort data=f.dt1;
by acres;
run;

/* 2. Sort data by a variable in descending order (highest is first) */
/* Example: Sort farms such that those with highest acreage are first */
proc sort data=f.dt1;
by descending acres;
run;

/* 3. Sort data by more than one variables. That is, sort within subgroups */
/* Example: Sort farms such that those with lowest acreage in each year are first */

proc sort data=f.dt1;
by year acres;
run;

/* b. Removing/keeping certain observations */
/* 1. Remove specific observations */
/* Example: Remove farms that are named "Wheater" */
data f.dt2;
set f.dt1;
if farm="Wheater" then delete;
run;

/* 2. Remove observations according to a criteria */
/* Example: Remove all farms that have acreage above or equal to 1,000 */
data f.dt3;
set f.dt1;
if acres >= 1000 then delete;
run;

/* 3. Keep observations according to a criteria */
/* Example: Keep only farms that have acreage between 300 and 900 acres */
data f.dt4;
set f.dt1;
if 300 < acres <= 900;
run;

/* 4. Remove missing observations */
/* Example: Remove farms that have a missing observation for acres */
data f.dt5;
set f.dt1;
if acres = . then delete;
run;

/* c. Manipulating variables (columns) */
/* 1. Keep only certain variables from an original data set */
/* Example: Keep only the year and farm name variables */
data f.dt6;
set f.dt1(keep=year farm);
run;

/* 2. Delete certain variables from the original data set */
/* Example: Drop the farm number and acreage variables */
data f.dt7;
set f.dt1(drop=record acres);
run;

/* 3. Rename variable names */
/* Example: Rename the year variable from "year" to "year_t" */
data f.dt8;
set f.dt1(rename=(year=year_t));
run;

proc print data=f.dt8;
run;

/* 4. Convert a character variable into a numeric */
/* Example: Convert the character variable describing the number of
chickens on a farm into a numeric format */
data f.dt9;
set f.dt1;
chickN = input(chickens, 8.);
drop chickens;
label chickN="Number of chickens";
run;

proc contents data=f.dt1;
run;
proc contents data=f.dt9;
run;

/* Advanced data manipulation */
/* First, let�s create four new data sets for us to use (dt10-dt13)*/

data f.dta10;
input record year farm $ acres chickens $2.;
label record="Farm Number"
  year="Year"
  farm="Farm Name"
  acres="Planted Acres"
  chickens="Number of chickens"
;
datalines;
2 1999 HappyFam 554 44
1 1999 MmDonuts 334 32
3 1999 NoRecord . .
5 1999 TinyCow 1234 56
8 1999 Wheater 442 12
14 1999 Deere 994 72
;
run;
data f.dta11;
input record year farm $ acres chickens $2.;
label record="Farm Number"
  year="Year"
  farm="Farm Name"
  acres="Planted Acres"
  chickens="Number of chickens"
;
datalines;
2 2000 HappyFam 554 35
1 2000 MmDonuts 324 41
3 2000 NoRecord . .
5 2000 TinyCow 1532 76
8 2000 Wheater 442 9
14 2000 Deere 763 63
;
run;
data f.dta12;
input record year farm $;
label record="Farm Number"
year="Year"
  farm="Farm Name"
;
datalines;
2 1999 HappyFam
1 1999 MmDonuts
3 1999 NoRecord
5 1999 TinyCow
8 1999 Wheater
14 1999 Deere
1 2000 MmDonuts
2 2000 HappyFam
3 2000 NoRecord
5 2000 TinyCow
8 2000 Wheater
14 2000 Deere
;
run;

data f.dta13;
input farm $ acres chickens $2.;
label farm="Farm Name"
  acres="Planted Acres"
  chickens="Number of chickens"
;
datalines;
 HappyFam 554 44
 MmDonuts 334 32
 NoRecord . .
 TinyCow 1234 56
 Wheater 442 12
 Deere 994 72
 MmDonuts 324 41
 HappyFam 604 35
 NoRecord . .
 TinyCow 1532 76
 Wheater 204 9
 Deere 763 63
 

; run;
/* a. Setting one data set into another: Vertical concatenation of data sets */
/* Example: Set the dataset "dta11" onto "dta10" */
data f.dta14;
set f.dta10 f.dta11;
run;


/* b. Merging data sets together */
/* Example: Merge data sets "dta12" and "dta13" together by farm name to create data set 15 (dta15)*/
proc sort data=f.dta12;
by farm;
run;

proc sort data=f.dta13;
by farm;
run;

data f.dta15;
merge f.dta12 f.dta13;
by farm;
run;

/* c. Append data sets */
/* Example: Append data set "dta11" to "dta10" */
proc append base=f.dta10
data=f.dta11
force;
run;

/* d. Exporting a SAS data set */
/* Method 1: Use the SAS wizard to export a data set */
/* Method 2: Code the export of a data set */
PROC EXPORT DATA= F.Dta10 
            OUTFILE= "C:\Users\madariagajf\Desktop\f\Farm Data.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
 
/* Exploring and summarizing the data */
/* a. Producing basic summary statistics of the data set */
/* Example 1: Default summary statistics about all variables in a data set */

proc means data=f.dt1;
run;

/* Example 2: Default summary statistics about only specific variables */

proc means data=f.dt1;
var acres;
run;

/* Example 3: Selected summary statistics */
proc means data=f.dt1 n nmiss mean median std;
run;

/*Example 4:  Correlation */
proc corr data=f.dt1;
run;


/* b. Frequency statistics */
/* 1. Basic frequency and additional statistics */
proc univariate data=f.dt1;
run;

/* 2. Descriptive frequency statistics */
proc freq data=f.dt1;
tables farm acres;
run;
 

/* c. Visualizing the data -- graphics */
/* 1.  Producing a basic scatter plot of the data */
/* Example: Seeing acreage as a function of farm number */
ods graphics on;
proc sgplot data=f.dt1;
scatter x=record y=acres;
run;
ods graphics off;

/* 2. Producing a series plot (i.e. connecting the dots) */


proc sort data=f.dta14;
by farm;
run;

data f.dta14;
set f.dta14;
if farm="NoRecord" then delete;
run;

ods graphics on;
proc sgplot data=f.dta14;
by farm;
series x=year y=acres;
run;
ods graphics off;



/* 3. Producing a bar graph */
/* Example: Bar chart of acres on farms in 1999 */
ods graphics on;
proc sgplot data=f.dt1;
where year=1999;
vbar farm / response=acres;
run;
ods graphics off;

/* Example: Bar chart of comparing acres in 1999 and 2000*/
data f.dt1graph; 
set f.dt1;
if year = 1999 then acres99 = acres;
if year = 2000 then acres00 = acres;
label acres99 = "Acres in 1999"
  acres00 = "Acres in 2000";
run;

ods graphics on;
proc sgplot data=f.dt1graph;
yaxis label = "Acreage";
vbar farm / response=acres99;
vbar farm / response=acres00
barwidth=0.5
transparency=0.2;
run;
ods graphics off;

/* 4. Producing a histogram and density curve */
/* Example: Distribution of acreage */
ods graphics on;
proc sgplot data=f.dt1;
histogram acres;
density acres / type=normal;
run;
ods graphics off;


