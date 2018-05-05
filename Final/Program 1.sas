/* 	Neal Sakash
	ECON 419
	HW4Q6 */

/* Problem One */
/* Birthweight_Smoking */
FILENAME REFFILE '/folders/myfolders/final/birthweight_smoking.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.birthweight_smoking;
	GETNAMES=YES;
RUN;

/* i */
/* Smokers */
proc means data=work.birthweight_smoking;
where smoker = 1;
run;


/* Final_Crime */
FILENAME REFFILE '/folders/myfolders/final/final_crime.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.final_crime;
	GETNAMES=YES;
RUN;