'Regression Code:'
#Regression ----

#Combining profit and variables:

#So this is an issue I am running into: a ton of the households have a negative
#profit. I wanted to compare their agricultural profit to their overall hpusehold
#income, so I looked at AGG2: 


compare_prof <- read_dta("Data/glss4_new/aggregates/agg2.dta") %>%
  unite('hh_id', nh, clust)%>%
  left_join(hhid_agprofit)

nonagg_income <- read_dta("Data/glss4_new/aggregates/agg2.dta") %>%
  unite('hh_id', nh, clust) %>%
  inner_join(hhid_agprofit) %>%
  mutate('subagg_totalinc' = agri2c,
         'agri_inc' = total_inc)%>%
  select(hh_id, agri_inc, subagg_totalinc, profit) 

#That didn't tell me all that much. Instead, I wanted to try running some regressions
#on ONLY those who actually made a profit, so: