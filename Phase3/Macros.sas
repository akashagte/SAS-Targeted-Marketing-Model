
%Macro DissGraphMakerLogOdds(dsn,groups,indep,dep);
proc summary data=&dsn;
var &indep;
output out=Missing&indep nmiss=;
run;

data Missing&indep;
set  Missing&indep;
PctMiss=100*(&indep/_freq_);
rename &indep=NMiss;
run;

data _null_;
set  Missing&indep;
call symput ('Nmiss',Compress(Put(Nmiss,6.)));
call symput ('PctMiss',compress(put(PctMiss,4.)));
run;

proc rank data=&dsn groups=&groups out=RankedFile;
var &indep;
ranks Ranks&indep;
run;

proc summary data=RankedFile nway missing;
class Ranks&indep;
var &dep &indep;
output out=GraphFile mean=;
run;

data graphfile;
set  graphfile;
logodds=log(&dep/(1-&dep));
run;

data graphfile setaside;
set  graphfile;
if &indep=. then output setaside;
else             output graphfile;
run;

data _null_;
set  setaside;
call symput('LogOdds',compress(put(LogOdds,4.2)));
run;

proc plot data=graphfile;
plot LogOdds*&indep=' ' $_FREQ_ /vpos=20;
title "&dep by &groups Groups of &indep NMiss=&Nmiss PctMiss=&PctMiss%  LogOdds in Miss=&LogOdds"
;
run;
title;
quit;
%Mend DissGraphMakerLogOdds;


%macro ObsAndVars(dsn);
%global nobs nvars;
%let dsid=%sysfunc(open(&dsn));   
%let nobs=%sysfunc(attrn(&dsid,nobs));     
%let nvars=%sysfunc(attrn(&dsid,nvars));   
%let rc=%sysfunc(close(&dsid));            
%put nobs=&nobs nvars=&nvars;   
%mend ObsAndVars;


%macro varlist(dsn);
options nosymbolgen;
 %global varlist cnt;
 %let varlist=;

/* open the dataset */
 %let dsid=%sysfunc(open(&dsn));

/* count the number of variables in the dataset */
 %let cnt=%sysfunc(attrn(&dsid,nvars));

 %do i=1 %to &cnt;
 %let varlist=&varlist %sysfunc(varname(&dsid,&i));
 %end;

/* close the dataset */
 %let rc=%sysfunc(close(&dsid));
*%put &varlist;
%mend varlist;

