libname f "";
run;

/* PROC IMPORT OUT= F.Fertility1  */
/*             DATAFILE= "C:\Users\Neal\Documents\CofC\2018\ECON 419\SASUniversityEdition\myfolders\f\fertil.csv"  */
/*             DBMS=CSV REPLACE; */
/*      GETNAMES=YES; */
/*      DATAROW=2;  */
/* RUN;  */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/folders/myfolders/f/fertil.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=work.import;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

data Fertility1;
set work.import;
run;

Proc means data = work.Fertility1;
run;

/*Question One*/
/*Min: 0 Max: 13 Average: 2.27*/

proc univariate data=work.Fertility1;
var electric;
run;
/*Question Two*/
/*611/4358=14%*/

/*Question Three  */
data work.fertChildElectric;
set work.Fertility1 (keep=children electric );
run;

data work.fertChildwithoutElectric;
set work.Fertility1 (keep=children electric );
if electric = 1 then delete;
run;

proc means data=work.fertchildwithoutelectric;
run;
/* Mean is 2.3 children for families without electricity*/

data work.fertChildwithElectric;
set work.Fertility1 (keep=children electric );
if electric = 0 then delete;
run;

proc means data=work.fertchildwithelectric;
run;
/* Mean is 1.9 children for families with electricity */