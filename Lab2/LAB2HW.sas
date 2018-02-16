/* Import Data */
%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/folders/myfolders/Lab2/Earnings_and_Height.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.earningsHeight;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

proc print data=work.earningsHeight(obs=5);
run;

/******************************************************************************************************************/

/*Basic data statistics*/
/*i*/
proc means data=work.earningsHeight;
var height;
run;

/*Average height = 66.79*/

/*ii*/
proc means data=work.earningsHeight;
where height<67;
var earnings;
run;

/*Average earnings for those less than 67" = $45,071.62*/

/*iii*/
proc means data=work.earningsHeight;
where height>67;
var earnings;
run;

/*Average earnings for those greater than 67" = $51,418.94*/

/*iv*/
proc sgplot data=work.earningsHeight;
scatter x = height y = earnings;
run;
/* There seems to be no correlation in this scatterplot. This may be due to earnings being expressed in brackets  */
/* instead of individual figures */

/******************************************************************************************************************/

/* Run a regression of Earnings on height. */
/* i */
proc reg data = work.earningsHeight;
model earnings = height;
run;
/* estimated slope: 819.26565(HEIGHT)*/
/* Equation: EARNINGS = -6984.69652	+ 819.26565(HEIGHT)*/

/* ii */
/* Estimated earnings */
/* 67" = $47,906.10  79" = $57,737.29  65" = $46,267.57*/

/* iii */
/* R^2 = 0.0143 */

/* Run a regression of Earnings on height, using data only for female workers.  */
proc reg data = work.earningsHeight;
where (sex = 0);
model earnings = height;
run;
/* i */
/* estimated slope: 513.62860(HEIGHT) */
/* regression equation: EARNINGS = 12843 + 513.62860(HEIGHT) */

/* ii */
proc means data=work.earningsheight;
where (sex = 0);
var height earnings;
run;
/* mean height for female workers: 64.49"  mean earnings: $45967.26*/
/* for a female work 65.49" tall, earnings are predicted to be $46480.54; higher than the mean by $513.28 */

/******************************************************************************************************************/


/* Run a regression of Earnings on height, using data only for male workers. */
proc reg data = work.earningsHeight;
where (sex = 1);
model earnings = height;
run;

/* i.	What is the estimated slope? ( 2 points) */
/* Slope: 1298.73146(HEIGHT) */
/* Regression equation: EARNINGS = -40779 + 1298.73146(HEIGHT) */

proc means data=work.earningsheight;
where (sex = 1);
var height earnings;
run;

/* ii.	A randomly selected male is 1 inch taller than the average male in the sample. Would you predict his earnings were higher or 
	lower than the average earnings for male in the sample? By how much? (5 points) */
	/* mean height for male workers: 70.13"  mean earnings: $50300.61 */
	/* for a male worker 71.13" tall, earnings are predicted to be $51599.77; higher than the mean by $1299.16 */

/* iii.	What is the intuition behind separating the sample into male and female samples? (5 points) */
	/* CP, on average, female samples would be shorter and male samples */

/* iv.	Do you think that height is uncorrelated with other factors that cause earnings? That is, do you
	think that the regression error term ui has a conditional mean of zero, given height? Briefly
	justify your answer. (5 points) */




