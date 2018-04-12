libname f"";
run;

proc means data=f.beer_con;
run;

/* Look at the error plots */
proc reg data=f.beer_con;
  model beer = male price_b price_c ; 
  title 'OLS for beer consumption';
  output out=f.resdat_ols residual=uhat_ols predicted=yhat_ols;
run;

proc print data=f.resdat_ols;
run;

/* We next test for heteroskedasticity by regressing the squared
residuals on male and price_c */

data f.resdat_ols_new;
  set f.resdat_ols;
  uhat2 = uhat_ols**2;
run;

proc reg data=f.resdat_ols_new;
  model uhat2 = male price_c;
  test male=price_c=0;
  title 'Test for heteroskedasticity';
  /*You could also do the LM test as described in class
  n*unadjusted R2 ==0.1795*500 = 89.75.  Compare this to the chi-square distribution 
  at any significant and reject null of homoskeasticity*/
run;

/* Re-run initial regression with the option 'acov' to compute
heteroskedasticity-robust variances and covariances */

proc reg data=f.beer_con;
  model beer = male price_b price_c / acov; 
  title 'OLS for beer consumption';
  test price_b=0, price_c=0;
run;


/* We next do a FGLS estimation using the 'weight' statement of SAS */
data f.resdat_ols_new1;
  set f.resdat_ols_new;
  log_res_2 = log(uhat_ols**2);
run;

proc reg data=f.resdat_ols_new1;
  model log_res_2 = male price_c;
  title 'Estimation and prediation of variance';
  output out=f.res_var predicted=log_h_hat;
run;
proc print data=f.res_var;
run; 

data f.res_var;
  set f.res_var;
  h_hat = exp(log_h_hat);
  one_over_h = 1/h_hat;
run;

proc reg data=f.res_var;
  model beer = male price_b price_c;
  weight one_over_h;
  title 'FGLS for beer consumption (using weight)';
run;

/*Doing WLS if we know the form of heteroskedasticity*/
/*New Data Set*/

data f.saving_new;
  set f.saving;
  h_hat = sqrt(inc);
  one_over_h = 1/h_hat;
run;

proc reg data=f.saving_new;
  model sav = inc;
  weight one_over_h;
  title 'WLS for beer consumption (using weight)';
run;
