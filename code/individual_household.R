'Individualized data:'
indiv_df <- roster %>%
  full_join(hhid_agprofit)%>%
  left_join(variables) %>%
  filter(profit > 0)    #positive profit only

'Overall household data:'
hh_df <- roster %>%
  full_join(hhid_agprofit)%>%
  left_join(variables) %>%
  filter(pid == 1) %>%  #only considers one individual/overall hh
  filter(profit > 0) %>% #again, positive profit only
  select(-pid)

#As a reminder, our variables are:

'Dummy'
#Male (1 = yes)
#Married (1 = yes)
#urban (1 = yes)
#ecowas (1 = from west Africa)
#coastal/savannah/forest (1 = hh is in respective climate)
#read_gha (1 = literate in ghanian language)
#read_eng (1 = literate in english language)
#fund_source (1 = had funding from parents)

'Quantitative'
#age
#rel_to_hoh (1 = head of household, 2 = spouse of head)
#educyrs
#water_dist_m (meters to nearest water source)#

'Individual regressions:'

individ_dummy_reg <- lm(formula = profit ~ male + married + ecowas + read_gha + read_eng +
                          fund_source, data = indiv_df)

summary(individ_dummy_reg)

#Estimate Std. Error t value Pr(>|t|)  
#(Intercept)   982987     348875   2.818   0.0372 *
#  male              NA         NA      NA       NA  
#married      -742599     427283  -1.738   0.1427  
#ecowas            NA         NA      NA       NA  
#read_gha       62783     427283   0.147   0.8889  
#read_eng          NA         NA      NA       NA  
#fund_source       NA         NA      NA       NA  

individ_quant_reg <- lm(formula = profit ~ age + rel_to_hoh + educyrs, data = indiv_df)
summary(individ_quant_reg)

#Estimate Std. Error t value Pr(>|t|)   
#(Intercept)   679018     701247   0.968  0.33304   
#age             4586       9387   0.489  0.62525   
#rel_to_hoh    309774     287586   1.077  0.28157   
'educyrs       117329      44503   2.636  0.00846 **'
