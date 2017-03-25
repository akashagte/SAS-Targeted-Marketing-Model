/*This program reads in FDIC bank branch data
  aggregates data to zip level for number of bank branches 
  and number of competitor branched
  output final data to a permanent dataset and csv file
*/  

/*library statement*/
*	Note: adjust this as necessary;
libname akash '/folders/myfolders/';

/*Get the data*/
*read in FDIC data*;
proc import datafile='/folders/myfolders/Practise/fdic_branch.csv' 
	out=branch_fdic dbms=csv replace;
run;

/*Check the data*/
proc contents data=branch_fdic;
title "Checking the imported data file";
run;
proc print data=branch_fdic (obs=10);
run;
title;

/*Create new data*/
**************************************************************************************;
proc sort data=branch_fdic;
by zip servtype;
run;
/*FI branch count*/
proc freq data=branch_fdic (where=(fi_uninum=589 and servtype=11)) noprint;
tables fi_uninum*zip*servtype / out=branch_count_fi (rename=(count=num_branches));
run;
proc print data=branch_count_fi (obs=10);
title "Bank branches output";
run;
title;
/*competitior branch count*/
proc freq data=branch_fdic (where=(fi_uninum^=589 and servtype=11)) noprint;
tables zip*servtype / out=branch_count_comp (rename=(count=num_branches_comp));
run;
proc print data=branch_count_comp (obs=10);
title "Competitor branches output";
run;
title;

/*merge dataset together
 keep only zipcodes where FI is located*/
data akash.branch_fi_comp_census;
merge branch_count_fi (drop=percent in=a) branch_count_comp (drop=percent in=b) prefactor (in=c);
by zip;
if a;
if a and ^b then num_branches_comp=0;
if a and ^c  then missing_census=1;
else missing_census=0;
run;
***QA;
proc print data=akash.branch_fi_comp_census ; *(obs=10);
title "merged data QA";
run;
title;

**************************************************************************************;

/*Output the data*/
**** create csv file;
proc export data=akash.branch_fi_comp_census 
	outfile='/folders/myfolders/out_branch_census.csv' 
	dbms=csv replace;
run;


/*sql example*/
proc sql;
create table branch_all_sql as
select '589' as fi_uninum_nm, zip, servtype, sum(fi_uninum=589) as num_branches, sum(fi_uninum^=589) as num_comp_branches
from branch_fdic
where servtype=11 and zip in
	(select distinct zip from branch_fdic where fi_uninum=589 and servtype=11)
group by 2,3
;
quit;
proc print data=branch_all_sql;
TITLE "sql data QA";
run;
title;
