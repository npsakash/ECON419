libname f"";
run;

/* Linear Test */

proc reg data=f.twoyear;
model lwage=jc univ exper;
run;

/*Test Beta1 = Beta2...
Theta = Beta1 - Beta2 = 0
Beta1 = theta + Beta2 (1)
lwage = beta0 + Beta1jc + Beta2univ + beta3exper (2)

Substitute (1) into (2)
lwage = beta0 + (theta+Beta2)jc + beta2univ + beta3exper
lwage = beta0 + thetajc + beta2jc + beta2univ + beta3exper
lwage = beta0 + theta jc + beta2(jc+univ) + beta3exper
So create variable 
total_university = (jc + univ)*/

data f.twoyear_update;
set f.twoyear;
total_university = jc + univ;
run;

proc reg data=f.twoyear_update;
model lwage = jc total_university exper;
run;

Title'Obtaining Critical Values (Quantiles)'; run;
data f.question4;
Z975 = PROBIT(.975);
Z950 = PROBIT(.950);
Z900 = PROBIT(.90);
proc print;run;

/*Or you can run the simple code to test the linear combination*/
proc reg data=f.twoyear_update;
model lwage=jc univ exper;
test jc-univ=0;
run;

/* Joint Test of Significance*/
proc reg data=f.mlb1;
model lsalary = years gamesyr;
run;

/*The SSR of the restricted model is 198.311 */

proc reg data=f.mlb1;
model lsalary = years gamesyr bavg hrunsyr rbisyr;
run;

/*The SSR of the unrestricted model is 183.186 */

/* The F-Stastitic is (198.311-183.186/ 183.186) * (347/3 = 9.55 */
data f.question5;
F_critical = FINV(.95, 3, 347);
proc print; run;

/*OR Calculate the test-statistic as follows*/

proc reg data=f.mlb1;
model lsalary = years gamesyr bavg hrunsyr rbisyr;
test bavg=hrunsyr=rbisyr=0;
run;

proc reg data=f.mlb1;
model lsalary = years gamesyr bavg hrunsyr rbisyr / tol  collin vif;
run;

/* Re-Scaling either the dependent or indpendent variable */
data f.bwght1;
set f.bwght;
bwghtlbs = bwght/16;
pack =cigs/20;
lbwght = log(bwght);
lbwghtlbs = log(bwghtlbs);
run;

proc reg data=f.bwght1;
model bwght = cigs faminc;
run;

/*Re-scaling*/
proc reg data=f.bwght1;
model bwghtlbs = cigs faminc;
run;

proc reg data=f.bwght1;
model bwght = packs faminc;
run;

/* Beta coeffiecients*/
proc reg data=f.bwght1;
model bwght = packs faminc/stb;
run;

/*Quadratic */
proc reg data=f.wage1;
model wage=exper expersq;
run;

proc freq data=f.wage1;
tables exper;
run;

data f.wage_new;
set f.wage1;
if exper<24 then delete;
run;

proc means data=f.wage_new;
var exper;
run;





