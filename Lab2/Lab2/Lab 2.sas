libname f"";
run;

/* We will be using a data file that was created by randomly sampling 400 elementary schools from the California Department of Educationís API 2000 dataset.  This data file contains a measure of school academic performance as well as other attributes of the elementary schools, such as, class size, enrollment, poverty, etc. 

Letís dive right in and perform a regression analysis using the variables api00, acs_k3, meals and full. 
These measure the academic performance of the school (api00), 
the average class size in kindergarten through 3rd grade (acs_k3), 
the percentage of students receiving free meals (meals) ÅEwhich is an indicator of poverty, and 
the percentage of teachers who have full teaching credentials (full). 

We expect that better academic performance would be associated with lower class size, fewer students receiving free meals, and a higher percentage of teachers having full teaching credentials. */

proc reg data=f.elemapi;
  model api00 = acs_k3 meals full;
run;

/* Letís focus on the three predictors, whether they are statistically significant and, if so, the direction of the relationship. The average class size (acs_k3, b=-2.68), is significant (p=0.0553) at the 10% level and the coefficient is negative which would indicate that larger class sizes is related to lower academic performance ÅEwhich is what we would expect.   

Next, the effect of meals (b=-3.70, p<.0001) is significant and its coefficient is negative indicating that the greater the proportion students receiving free meals, the lower the academic performance.  Please note, that we are not saying that free meals are causing lower academic performance.  The meals variable is highly related to income level and functions more as a proxy for poverty. Thus, higher levels of poverty are associated with lower academic performance. This result also makes sense.  

Finally, the percentage of teachers with full credentials (full, b=0.11, p=.2321) seems to be unrelated to academic performance. This would seem to indicate that the percentage of teachers with full credentials is not an important factor in predicting academic performance ÅEthis result was somewhat unexpected.

Should we take these results and write them up for publication?  From these results, we would conclude that lower class sizes are related to higher performance, that fewer students receiving free meals is associated with higher performance, and that the percentage of teachers with full credentials was not related to academic performance in the schools.  Before we write this up for publication, we should do a number of checks to make sure we can firmly stand behind these results.  We start by getting more familiar with the data file, doing preliminary data checking, looking for errors in the data. */
 
proc contents data=f.elemapi ;
run;

proc print data=f.elemapi(obs=5) ;
run;

proc print data=f.elemapi(obs=10) ;
  var api00 acs_k3 meals full;
run;

/* Another useful tool for learning about your variables is proc means. Below we use proc means to learn more about the variables api00, acs_k3, meals, and full.  */

proc means data=f.elemapi;
  var api00 acs_k3 meals full;
run;

/* We can also use proc freq to learn more about any categorical variables, such as yr_rnd, as shown below. */

proc freq data=f.elemapi;
  tables yr_rnd;
run;

/* let us look further into the average class size by getting more detailed summary statistics for acs_k3 using proc univariate.  */

proc univariate data=f.elemapi;
  var acs_k3;
run;

/* Looking in the section labeled Extreme Observations, we see some of the class sizes are -21 and -20, so it seems as though some of the class sizes somehow became negative, as though a negative sign was incorrectly typed in front of them.   Letís do a proc freq for class size to see if this seems plausible. */

proc freq data=f.elemapi;
  tables acs_k3;
run;

/*Indeed, it seems that some of the class sizes somehow got negative signs put in front of them.  Letís look at the school and district number for these observations to see if they come from the same district.   Indeed, they all come from district 140. */



proc print data=f.elemapi;
  where (acs_k3 < 0);
  var snum dnum acs_k3;
run;

/* Notice that when we looked at the observations where (acs_k3 < 0) this also included observations where acs_k3 is missing (represented as a period).  To be more precise, the above command should exclude such observations like this. */

proc print data=f.elemapi;
  where (acs_k3 < 0) and (acs_k3 ^= .);
  var snum dnum acs_k3;
run;

/* Now,  letís look at all of the observations for district 140. */

proc print data=f.elemapi;
  where (dnum = 140);
  var snum dnum acs_k3;
run;


/* Letís take a look at some graphical methods for inspecting data.  For each variable, it is useful to inspect them using a histogram.  This graph can show you information about the shape of your variables better than simple numeric statistics can. We already know about the problem with acs_k3, but letís see how the graphical method would have revealed the problem with this variable. */

proc freq data=f.elemapi;


proc univariate data=f.elemapi;
  var acs_k3 ;
  histogram / cfill=gray;
run;

proc univariate data=f.elemapi;
  var full ;
  histogram / cfill=gray;
run;

/*Letís look at the frequency distribution of full to see if we can understand this better.  The values go from 0.42 to 1.0, then jump to 37 and go up from there.   It appears as though some of the percentages are actually entered as proportions, e.g., 0.42 was entered instead of 42 or 0.96 which really should have been 96. */


/* Letís see which district(s) these data came from. */

proc freq data=f.elemapi ;
  tables full;
run;


/* We note that all 104 observations in which full was less than or equal to one came from district 401.  Letís see if this accounts for all of the observations that come from district 401.*/

/*!!!FOR HOMEWORK!!! 2-15-18*/
data f.elemapi2_new;
set f.elemapi;
full_new = full*100;
run;


proc freq data=f.elemapi ;
  where (dnum = 401);
  tables dnum;
run;

proc freq data=f.elemapi2 ;
  tables full;
run;

proc reg data=f.elemapi2;
  model api00 = acs_k3 meals full ;
run;
