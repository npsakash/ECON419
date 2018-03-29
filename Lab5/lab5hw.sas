proc means data=f.pntsprd;
var spread;
output out=f.stat(drop=_TYPE_ _FREQ_) mean=ms;
/*output to new dataset with means of three continuous variables*/
run;

/*i*/
proc sort data = f.pntsprd;
by decending favwin;
run;

proc reg data=f.pntsprd;
model favwin = spread;
run;

/*ii*/
proc reg data=f.pntsprd;
model favwin = spread;
test spread = 0;
run;
