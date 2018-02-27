libname f"";
run;
/* Understanding the partialling out effect, or ceteris paribus*/

/*i*/
proc means data=work.discrim;
var prpblck income;
run;
/*prpblck: mean = 0.113 Std Dev = 0.182; Proportion of black residents by zip code*/
/*income:  mean = 47053.78 Std Dev = 13179.29; income in dollars*/

/*ii*/
proc reg data=work.discrim;
model psoda = prpblck income;
run;
/*psoda = 0.956 + 0.11499(prpblck) + 0.00000160(income) + u*/
/*sample size: 401 R^2: 0.0642 Adj R^2: 0.0595*/
/*CP, for a 1 percentage point increase in prpblck there is an 1/100 cent increase*/

/*iii*/
proc reg data=work.discrim;
model psoda = prpblck;
run;
/*psoda = 1.03740 + 0.06493(prpblack)*/

