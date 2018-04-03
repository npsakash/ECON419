/* Neal Sakash */
/* ECON 419 */
/* 4-3-18 */
/* Lab Five */

FILENAME REFFILE '/folders/myfolders/Lab5/pntsprd.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.pntsprd;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.pntsprd; RUN;

/* Find mean of continuous variables */
proc means data=work.pntsprd;
var favscr undscr spread sprdcvr;
output out=work.stat(drop=_TYPE_ _FREQ_) mean=mfavscr mundscr mspread msprdcvr;
run;

/* Sort data on favwin */
proc sort data=work.pntsprd;
by descending favwin;
run;

/* i */
/* Since favwin is a binary variable, the model is predicting whether or not the favored team */
/* wins a game above or beneath the spread. So the probability is 50/50, therefore Beta0 woudl equal 0.5 */

/*ii*/
proc reg data=work.pntsprd;
model favwin = spread;
test intercept-spread=0;
run;
/* Ho: Beta0=0.5 */
/* Ha: Beta0!=0.5 */
/* t-crit: 1.96 at 5% significance level */
/* t-val: (0.57695-0.5)/0.02823 = 2.7258 */
/* t-val>t-crit, so reject Ho.  */

proc reg data=work.pntsprd;
model favwin = spread /acov;
run;
/* Ho: Beta0=0.5 */
/* Ha: Beta0!=0.5 */
/* t-crit: 1.96 at 5% significance level */
/* t-val: (0.57695-0.5)/0.03160 = 2.4351 */
/* t-val>t-crit, so reject Ho.  */

/* iii */
proc reg data=work.pntsprd;
model favwin = spread /acov;
output out=work.linear_prob p=p_phat;
test spread=0;
/*outputs the predictive probabilities*/
run;
proc print data=work.linear_prob;
where spread=10;
run;
/* Spread is statistically significant with a p-value <0.0001 */
/* The estimated probability that the favored team wins when the spread equals 10 is 0.77060 or 77.06% */

/* iv */
/*Estimation of the probit model*/
proc logistic data=work.pntsprd order=data outest=work.probit_param;
model favwin=spread/link=normit;
output out=work.probitprobs p=probit_phat;
run;
/* Ho: Beta0=0 */
/* Ha: Beta0!=0 */
/* t-crit: 1.96 at 5% significance level */
/* t-val: -0.0105/0.1035 = -0.1014 */
/* t-val<t-crit, so fail reject Ho.  */

/* v */
proc print data=work.probitprobs;
where spread=10;
run;
/* The estimated probability that the favored team wins when the spread equals 10 is 0.81964 or 81.96%  */
/* So the probit model gives a probability that is slightly higher than the LPM model */





