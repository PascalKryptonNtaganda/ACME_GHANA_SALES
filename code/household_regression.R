'Household regressions:'

hh_dummy_reg <- lm(formula = profit ~ urban + coastal + savannah + forest, data = hh_df)
summary(hh_dummy_reg)

#Estimate Std. Error t value Pr(>|t|)    
#(Intercept)  1499696     246935   6.073 1.77e-09 ***
'  urban         656604     389335   1.686   0.0920 .'  
#coastal1      268182     403048   0.665   0.5060    
'savannah1    -844187     400162  -2.110   0.0351 *'
#  forest1           NA         NA      NA       NA 

hh_quant_reg <- lm(formula = profit ~ water_dist_m, data = hh_df)
summary(hh_quant_reg)

#Estimate Std. Error t value Pr(>|t|)    
#(Intercept)   1.302e+06  1.779e+05   7.317 6.86e-13 ***
#  water_dist_m -3.143e+00  1.893e+01  -0.166    0.868   

'So the only thing I saw here that looked even remotely like correlation was
individual education years. Checking again:'

educ_reg <- lm(formula = profit ~ educyrs, data = indiv_df)
summary(educ_reg)


#(Intercept)  1336731     162553   8.223 3.95e-16 ***
#  educyrs       106223      43160   2.461    0.014 *  
