/* 	Neal Sakash
	ECON 419
	Final Exam */

/* Problem One */
/* Birthweight_Smoking */
%web_drop_table(WORK.birthweight_smoking);
FILENAME REFFILE '/folders/myfolders/final/birthweight_smoking.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.birthweight_smoking;
	GETNAMES=YES;
RUN;

%web_drop_table(WORK.birthweight_smoking);

/* Sort by smoker */
proc sort data=work.birthweight_smoking;
by descending smoker;
run; 

/* i */
/* Non-Smokers */
proc means data=work.birthweight_smoking;
where smoker = 0;
run;
/* Smokers */
proc means data=work.birthweight_smoking;
where smoker = 1;
run;

/* ii */
/* Discuss */

/* iii */
/* Regression */
/* Non-Smoker */
proc reg data=work.birthweight_smoking;
/* where smoker = 0; */
model birthweight = smoker/acov;
run;
/* iv */
/* Discuss */

/* v */
/* Discuss */

/* vi */
proc reg data=work.birthweight_smoking;
model birthweight = smoker alcohol tripre1 tripre2 tripre3;
run;

/* vii */
/* Breusch-Pagan */
proc reg data=work.birthweight_smoking;
model birthweight = smoker alcohol tripre1 tripre2 tripre3;
output out=work.res_birthweight_smoking residual=u_hat predicted=y_hat;
run;
 
data work.res_birthweight_smoking;
set work.res_birthweight_smoking;
u_hat_2 = u_hat*u_hat;
run;

proc reg data=work.res_birthweight_smoking;
model u_hat_2 = alcohol tripre3;
run;

/* Harvey-Godfrey */
data work.res_birthweight_smoking;
set work.res_birthweight_smoking;
ln_u_hat_2 = log(u_hat_2);
run;

proc reg data=work.res_birthweight_smoking;
model ln_u_hat_2 = alcohol tripre3;
run;

/* White */
data work.res_birthweight_smoking;
set work.res_birthweight_smoking;
y_hat_2 = y_hat*y_hat;
run;

proc reg data=work.res_birthweight_smoking;
model u_hat_2 = y_hat y_hat_2;
run;

/* viii */
/* FGLS */
proc reg data=work.res_birthweight_smoking;
model ln_u_hat_2=smoker alcohol tripre1 tripre2 tripre3;
output out=work.res_birthweight_smoking_var predicted=log_h_hat;
run;

data work.res_birthweight_smoking_var;
set work.res_birthweight_smoking_var;
h_hat=exp(log_h_hat);
one_over_h=1/h_hat;
run;

proc reg data=work.res_birthweight_smoking_var;
model birthweight = smoker alcohol tripre1 tripre2 tripre3;
weight one_over_h;
test  tripre1=tripre2=tripre3=0;
title 'FGLS for Birthweight(weighted)';
run;

/* ix */
/* FGLS – smoker, alcohol, nprevisit, unmarried */

proc reg data=work.birthweight_smoking;
model birthweight = smoker alcohol nprevist unmarried;
output out=work.res_birthweight_smoking_um residual=u_hat predicted=y_hat;
run;

data work.res_birthweight_smoking_um;
set work.res_birthweight_smoking_um;
u_hat_2=u_hat*u_hat;
ln_u_hat_2=log(u_hat_2);
run;

proc reg data=work.res_birthweight_smoking_um;
model ln_u_hat_2=smoker alcohol nprevist unmarried;
output out=work.res_birthweight_smoking_um_var predicted=log_h_hat;
run;

data work.res_birthweight_smoking_um_var;
set work.res_birthweight_smoking_um_var;
h_hat=exp(log_h_hat);
one_over_h=1/h_hat;
run;

proc reg data=work.res_birthweight_smoking_um_var;
model birthweight = smoker alcohol nprevist unmarried;
weight one_over_h;
title 'FGLS for Birthweight(weighted)';
run;



/*  */
/*  */


/* Final_Crime */
%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/folders/myfolders/final/final_crime.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.crime;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.crime; RUN;


%web_open_table(WORK.IMPORT);

data work.final_crime;
set work.crime;
run;

/* i */
proc means data=work.final_crime;
run;

/* ii */
/* Discuss */

/* iii */
data work.final_crime1;
set work.final_crime;
arr86 = narr86 > 0;
run;

proc sort data=work.final_crime1;
by descending arr86;
run;

/* iv */
proc reg data=work.final_crime1;
model arr86 = pcnv avgsen tottime ptime86 inc86 black hispan born60/acov;
output out=work.final_crime1_prob predicted=y_hat residual=u_hat;
run;

/* v */
proc means data=work.final_crime1_prob;
var y_hat;
run;

/* Replace variables less than 0 */
data work.final_crime1_prob;
set work.final_crime1_prob;
new_yhat= .;
if y_hat<0 then new_yhat=.0001;
else new_yhat = y_hat;
run;

proc means data=work.final_crime1_prob;
run;

/* LPM Formula */
data work.final_crime1_gls;
set work.final_crime1_prob;
one_minus_yhat = 1-new_yhat;
h_hat=new_yhat*one_minus_yhat;
one_over_h=1/h_hat;
run;

/* Weighted GLS Regression */
proc reg data=work.final_crime1_gls;
model arr86 = pcnv avgsen tottime ptime86 inc86 black hispan born60/acov;
weight one_over_h;
title 'GLS for Linear Probability Model';
run;

/* vi */
proc sort data=work.final_crime1_prob;
by descending arr86;
run;

/* Get means of model variables*/
proc means data=work.final_crime1_prob;
var avgsen tottime inc86 ptime86;
output out=work.stat(drop=_TYPE_ _FREQ_) mean=mavgsen mtottime minc86 mptime86;
run;

/* Probit */
proc logistic data=work.final_crime1_prob order=data outest=work.probit_param;
model arr86 = pcnv avgsen tottime inc86 ptime86 black hispan born60/link=normit;
output out=work.probitprobs predicted=probit_phat;
run;

data work.estprobit;
merge work.probit_param work.stat;
xBeta25 = intercept + pcnv*.25 + avgsen*mavgsen - tottime*mtottime - inc86*minc86 - ptime86*mptime86 + black;
xBeta75 = intercept + pcnv*.75 + avgsen*mavgsen - tottime*mtottime - inc86*minc86 - ptime86*mptime86 + black;
est_xBeta = probnorm(xBeta75)-probnorm(xBeta25);
run;

proc print data=work.estprobit;
var est_xBeta;
run;

/* vii  */
/* Joint Significance */
/* UR */
proc print data=work.probit_param;
run;

/* R */
proc logistic data=work.final_crime1_prob order=data outest=work.probit_param_r;
model arr86 = pcnv inc86 ptime86 black hispan born60/link=normit;
/* output out=work.probitprobs p=probit_phat; */
run;
proc print data=work.probit_param_r;
run;

/* viii */
/* Discuss */

/* ix */
/* Logit */
proc logistic data=work.final_crime1_prob order=data outest=work.logit_param;
model arr86 = pcnv avgsen tottime inc86 ptime86 black hispan born60/link=logit;
output out=work.logitprobs p=logit_phat;
run;

data work.estlogit;
merge work.logit_param work.stat;
xBeta25L = intercept + pcnv*.25 + avgsen*mavgsen - tottime*mtottime - inc86*minc86 - ptime86*mptime86 + black;
xBeta75L = intercept + pcnv*.75 + avgsen*mavgsen - tottime*mtottime - inc86*minc86 - ptime86*mptime86 + black;
est_xBetaL = exp(xBeta75L)/(1+exp(xBeta75L))-exp(xBeta25L)/(1+exp(xBeta25L));
run;

proc print data=work.estlogit;
var est_xBetaL;
run;

/* x */
/* Percent Correctly Predicted */
/* data work.final_crime1_prob; */
/* do arr86='1','0'; */
/* 	input Count @@; */
/* 	output; */
/* end; */
/* datalines; */
/* 2725 50 */
/* 50 2725 */
/* ; */
/* proc logistic data=work.final_crime1_prob order=data outest=work.probit_param; */
/* freq arr86; */
/* model arr86(event=1) = pcnv avgsen tottime inc86 ptime86 black hispan born60/link=normit */
/* 	/ pevent=.5 .01 ctable pprob=.5; */
/* run; */

proc logistic data=work.probitprobs order=data;
model arr86(event='1') = pcnv avgsen tottime inc86 ptime86 black hispan born60/ctable pprob=.5;
run;

proc logistic data=work.probitprobs order=data;
model arr86(event='0') = pcnv avgsen tottime inc86 ptime86 black hispan born60/ctable pprob=.5;
run;
 
/* Code from SAS Documentation */
/* data Screen; */
/*    do Disease='Present','Absent'; */
/*       do Test=1,0; */
/*          input Count @@; */
/*          output; */
/*       end; */
/*    end; */
/*    datalines; */
/* 950  50 */
/*  10 990 */
/* ; */
/*  */
/* proc logistic data=Screen; */
/*    freq Count; */
/*    model Disease(event='Present')=Test  */
/*          / pevent=.5 .01 ctable pprob=.5; */
/* run; */

