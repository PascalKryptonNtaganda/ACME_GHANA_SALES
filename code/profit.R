'Profit Code:'
#Profit ----

hhid_agprofit <- total_inc %>%
  full_join(total_exp, by = 'hh_id') %>%
  replace(is.na(.), 0) %>%
  mutate(profit = total_inc - total_exp) %>%
  group_by(hh_id) %>%
  select(hh_id, total_inc, total_exp, profit)