PROC IMPORT OUT= F.FERTILITY1 
            DATAFILE= "C:\Users\npsakash\Desktop\f\fertil.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
