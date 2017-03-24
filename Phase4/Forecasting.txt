/*This program creates the model. */
/*change program to fit your data and model*/

libname storage '/folders/myfolders/';


/*creating test and training data*/

data storage.model_ds;
set  storage.model_vars;

rand=ranuni(092765);
testdata=0;
if rand <=.7 then Resptest=.;
else if rand  >.7 then do;
	testdata=1;
    Resptest=Resp;
   	Resp=.;
end;
run;
proc print data=storage.model_ds (obs=10);
run;

/*logistic model*/
  *Adjust the variables to make YOUR model;
proc logistic data=storage.model_ds descending;
model resp=
mostyp2
mostyp3 
mostyp4 
mostyp5 
mostyp6 
mostyp7 
mostyp8 
mostyp9 
mostyp10 
mostyp11 
mostyp12 
mostyp13 
mostyp15 
mostyp16 
mostyp17 
mostyp18 
mostyp19 
mostyp20 
mostyp21 
mostyp22 
mostyp23 
mostyp24 
mostyp25 
mostyp26 
mostyp27 
mostyp28 
mostyp29 
mostyp30 
mostyp31 
mostyp32 
mostyp33 
mostyp34 
mostyp35 
mostyp36 
mostyp37 
mostyp38 
mostyp39 
mostyp40 
mostyp41
MSKB12
MAANTH
moshoo1 
moshoo2 
moshoo3 
moshoo4 
moshoo5 
moshoo6 
moshoo7 
moshoo9  
moshoo10
MGODPR2
MGEMLE2
MFALLE2
MSKA2
MAUT22
MFWEKI2
MRELGE2
MAUT12
MAUT02
MHHUUR2
MOPLHO2
MSKB22
MSKC2
MGODRK2
MGEMOM
MINKGE2
PPERSA2
PAANHA2
PWAPAR2
PWAPAR2SQ
AMOTSC
AWAPAR
APERSA
/selection=stepwise;
output out=scored p=pred;
run;

proc print data=scored (where=(testdata=1) obs=10);
run;

/*creating data for gains chart*/
proc sort data=scored;
by testdata;
run;

proc rank data=scored groups=100 ties=high out=scoredrank;
by testdata;
var pred;
ranks mscore;
run;

proc sql;
create table tt as
select ((100-mscore)/100) as rank, ((100-mscore)/100) as random, sum(resp) as resp_development, sum(resptest) as resp_test
from scoredrank
group by 1,2
order by 1,2
;
quit;

/****there may be overfitting***/
/*check the model*/
proc logistic data=storage.model_ds descending;
model resp= mostyp25 mostyp34 moshoo1 moshoo2
			mrelge2 mskc2 paanha2 amotsc MAUT12;
output out=scored_chk p=pred;
run;
quit;

proc sort data=scored_chk;
by testdata;
run;

proc rank data=scored_chk groups=100 ties=high out=scoredrank_chk;
by testdata;
var pred;
ranks mscore;
run;

proc sql;
create table tt_chk as
select ((100-mscore)/100) as rank, ((100-mscore)/100) as random, sum(resp) as resp_development, sum(resptest) as resp_test
from scoredrank_chk
group by 1,2
order by 1,2
;
quit;

/*explaining the model to your business partner*/

proc reg data=storage.model_ds;
model resp= mostyp25 maut12 mostyp34 moshoo1 moshoo2
			mrelge2 mskc2 paanha2 amotsc;
run;
quit;

/*save the model for execution*/

proc logistic data=storage.model_ds descending
			outmodel=storage.log_resp_model;
model resp= mostyp25 maut12 mostyp34 moshoo1 moshoo2
			mrelge2 mskc2 paanha2 amotsc;
run;
quit;



