/*library statement*/
*	Note: adjust this as necessary;
libname storage '/folders/myfolders/';

/*Check the data*/
proc contents data=storage.dmefzip position;
title "Contents of Zipcode Demographic File";
run;
proc print data=storage.dmefzip (obs=10);
run;
title;

/*Look at the data*/
*******************************************************************8888;
proc means data=storage.dmefzip;
title "Summary Statistics for Zipcode File";
run;
title;


proc means data=storage.dmefzip n nmiss maxdec=0;
title "Missing Values Report for Zipcode File";
run;
title;


*figure out number of records affected and RELEVANT number of variables;
*count number of variables with missing values per record;
data temp;
set  storage.dmefzip;
nummiss=nmiss(of DMAWLTHR--populat);
run;

*isolate records with at least 1 missing value;
data missing;
set  temp;
if   nummiss>0;
run;

*count total number of missing values;
proc means data=missing sum;
var nummiss;
run;

proc datasets lib=work nolist;
delete temp missing;
quit;
run;
*************************************************************************************88;

*****Changing the variables;
proc standard data=storage.dmefzip replace out=prefactor;
run;

*****QA;
proc means data=prefactor n nmiss maxdec=0;
title "Missing Values Report for Zipcode File After Mean Replacement";
run;
title;


*******************************************************************************;
*checking to see if factor analysis is appropriate;
proc corr data=prefactor rank;
run;


*Factor analysis standardization;
proc standard data=prefactor out=storage.standard mean=0 std=1;
var _numeric_;
run;

*****QA;
proc means data=storage.standard nmiss mean std maxdec=0;
title "Report for Zipcode File After Standardization";
run;
title;

*Look at the data*;
proc print data=storage.standard (obs=10);
run;

proc sort data=storage.standard;
by zipcode;
run;

*first pass of FA- looking a all factors;
proc factor data=storage.standard scree mineigen=0 ;
run;

*second pass of FA- how many factors we want to keep;
proc factor data=storage.standard rotate=varimax scree mineigen=1 fuzz=.4;
run;

*third pass of FA- final # factors we want to keep;
proc factor data=storage.standard rotate=varimax scree nfactors=5 fuzz=.4;
run;

*create scores;
proc factor data=storage.standard rotate=varimax scree nfactors=5 fuzz=.4 out=storage.census_factors;
run;
proc print data=storage.census_factors (obs=10);
run;
