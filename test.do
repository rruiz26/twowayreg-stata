// test of twest using USRDS data
 
// command varlist(numeric ts fv) [if] [in] [using/], 
// ABSorb(varlist min=2 max=3) [GENerate(namelist) NOPROJ] 
// [, NEWVars(name) REPLACE] [, VCE(namelist)]

/*
To test:
- storing of matrix when using path 
- using gernerate to create new group identifier 
- test different standard errors
- test twres
- test twsave and twload 
*/
clear
set more off
cap log close

do "/disk/homedirs/`c(username)'/usrds_na/`c(username)'/code/constrained-demand/set_globals.do"


do twest.ado

						
use "`temp'/gibbs_data_modified.dta", replace

reghdfe dist mean_np, absorb(month_year zip_pat) vce(robust)

/*
HDFE Linear regression                            Number of obs   =     15,066
Absorbing 2 HDFE groups                           F(   1,  14289) =       0.10
                                                  Prob > F        =     0.7528
                                                  R-squared       =     0.5203
                                                  Adj R-squared   =     0.4942
                                                  Within R-sq.    =     0.0000
                                                  Root MSE        =     0.9135

------------------------------------------------------------------------------
             |               Robust
        dist |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   mean_np_5 |  -.0001264   .0004012    -0.31   0.753    -.0009129    .0006601
       _cons |   2.673368    .048139    55.53   0.000     2.579009    2.767726
------------------------------------------------------------------------------

Absorbed degrees of freedom:
-----------------------------------------------------+
 Absorbed FE | Categories  - Redundant  = Num. Coefs |
-------------+---------------------------------------|
  month_year |        36           0          36     |
     zip_pat |       741           1         740     |
-----------------------------------------------------+
*/



twfem reg dist mean_np, absorb(month_year zip_pat) newv(w_) vce(robust)
//no observations 

//twfem reg w_y w_x1, noproj vce(cluster hhid)
//twfem ivregress 2sls w_y w_x1 (w_x2= w_x3), noproj vce(robust)