libname f"";
run;

/*Before performing any estimations we calculate the means of the 
continuous explanatory variables because these will be needed to calculate
the derivatives below*/

proc means data=f.vote;
var years loginc ptcon;
output out=f.stat(drop=_TYPE_ _FREQ_) mean=my ml mp;
/*output to new dataset with means of three continuous variables*/
run;

/*Sort the data*/
proc sort data=f.vote;
by descending yesvm;
/*All events where y=1 first*/
run;

/*Estimation of the linear probability model */
/*"/acov" corrects for heteroskedasticity*/
proc reg data=f.vote;
model yesvm=pub12 pub34 pub5 priv years school logINC PTCON /acov;
output out=f.linear_prob p=p_phat;
/*outputs the predictive probabilities*/
run;

proc print data=f.linear_prob;
where p_phat>=1;
run;

/*Estimation of the logit model*/
/*Link=logit for logit model*/
/*Link=normit for probit model*/
/*outest for parameter estimates*/
proc logistic data=f.vote order=data outest=f.logit_param;
model yesvm = PUB12 PUB34 PUB5 priv years school loginc ptcon/link=logit;
output out=f.logitprobs p=logit_phat;
run;

/*Estimation of the probit model*/
proc logistic data=f.vote order=data outest=f.probit_param;
model yesvm = PUB12 PUB34 PUB5 PRIV YEARS School loginc PTCON/link=normit;
output out=f.probitprobs p=probit_phat;
run;
data f.probs;
merge f.logitprobs f.probitprobs;
keep yesvm logit_phat probit_phat;
run;

/*Calculate the derivative of the probability that an individual votes YES evaluated at the mean of the continuous variables */
/*ask her about this section again*/
data f.diflogit;
merge f.logit_param f.stat;
x12 = intercept + pub12 + my*years + ml*loginc + mp*ptcon;
/*x12 families with 1-2 children in public schools*/
x0= intercept + my*years + ml*loginc + mp*ptcon;
/*x0 are all people without children in school and not teachers*/
/*difference between those with 1-2 children in public school or without children*/

difI = loginc * exp(x12)/(1+exp(x12))**2;
dif12 = exp(x12)/(1+exp(x12)) - exp(x0)/(1+exp(x0));
/*probability that someone voted yes that had 1-2 children in public school minus those that voted no without children*/
run;

proc print data=f.diflogit;
var difI dif12;
/*14.48 percentage points more likely to vote yes if you have 1-2 children in public school*/
run;

data f.difprobit;
merge f.probit_param f.stat;
x12 = intercept + pub12 + my*years + ml*loginc + mp*ptcon;
x0= intercept + my*years + ml*loginc + mp*ptcon;
difI = loginc * sqrt(7/44)*exp(-(x12**2)/2);
dif12 = probnorm(x12) - probnorm(x0);
run;

proc print data=f.difprobit;
var difI dif12;
run;
