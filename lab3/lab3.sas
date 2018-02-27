
libname f"";
run;
/* Understanding the partialling out effect, or ceteris paribus*/

proc reg data=f.wage1;
model lwage= educ exper tenure;
run;

/*Everything but experience and tenure in the residual*/
proc reg data=f.wage1;
model educ=exper tenure;
output out=f.wage2 r=resid;
run;

proc print data=f.wage2;
run;

proc reg data=f.wage2;
model lwage = resid;
run;
/*CP,each aditional unit of education increase wage by 7%*/

/* Simulate data with two regressors */
data f.sim(drop=i e);
 call streaminit(12345);
 do i=1 to 10000;
		/* rand(distribution., mean, variance) */
         x1 = rand("Normal",2,2);
         x2 = rand("Normal",0,3);
         e = rand("Normal",0,1);
         y = 5 + 0.5*x1 + 0.75*x2 + e;
         output;
end; run ; 

/* Draw a random sample */
 proc surveyselect data=f.sim
/*smple replacement sample*/
 method=srs n=2500 seed=12345
   out=f.sim_sample noprint;
 run;
 
 proc corr data=f.sim_sample nomiss cov;
 run;

/* Perform regression with x1 and x2 (no omitted variable bias) */
 proc reg data=f.sim_sample;
 model y = x1 x2;
 run;
 /* Perform regression without x2 (omitted variable bias is small because correlation between x1 and x2 is small) */
 proc reg data=f.sim_sample;
 model y = x1;
 run;
 data f.sim_1(drop=i e);
 call streaminit(12345);
 do i=1 to 10000;
         x1 = rand("Normal",2,2);
         x2 = 0.9*x1+rand("Normal",0,3);
         x3 = rand("Normal",0,3);
         e = rand("Normal",0,1);
         y = 5 + 0.5*x1 + 0.75*x2 + e;
         output;
end; run ;
 proc surveyselect data=f.sim_1
 method=srs n=2500 seed=12345
   out=f.sim_sample1 noprint;
 run;
 proc corr data=f.sim_sample1 nomiss alpha cov;
 run;

/* Perform regression with x1 and x2 (no omitted variable bias) */
 proc reg data=f.sim_sample1;
 model y = x1 x2;
 run;
 /* Perform regression without x2 (omitted variable bias large because correlation between x1 and x2 is not small) */
 proc reg data=f.sim_sample1;
 model y = x1;
 run;

/* Perform regression with irrelevant variable x3 */
proc reg data=f.sim_sample1;
model y= x1 x2 x3;
run;
 
/* Simulate a five regressor model */
data f.sim_2(drop=i e);
call streaminit(12345);
do i=1 to 10000;
        x1 = rand("Normal",2,2);
        x2 = rand("Normal",0,3);
        if i<5000 then x3=1; else x3=0;
        if 5000<=i<9750 then x4=1; else x4=0;
        if i>=9750 then x5=1; else x5=0;
        e = rand("Normal",0,1);
        y = 5 + 0.5*x1 + 0.75*x2 + 0.8*x3 + 0.9*x4 + 1*x5 + e;
        output;
end; run;


/* Draw a random sample */
proc surveyselect data=f.sim_2
  method=srs n=2500 seed=12345
  out=f.sim_sample2 noprint;
run;
/* Perform regression with linearly dependent variable */
proc reg data=f.sim_sample2;
model y = x1 x2 x3 x4 x5;
run;
/* Perform regression with imperfect dependent variables
    and run multicollinearity diagnostics */
proc reg data=f.sim_sample2;
model y = x1 x2 x3 x4 / tol collin vif ;
 run;
/* over 10 in variance inflation shows extreme multicollinearity */



