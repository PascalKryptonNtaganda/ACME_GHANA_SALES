'This is the entirety of the income, expense, profit, variable, and regression 
files. To run it fast and dirty from top to bottom:'

# In RStudio: code > Run Line to End, or CTRL + ALT + E
'Libraries'
#Load Libraries: ----
library(tidyverse)
library(haven)

# Roster ----

roster <- read_dta("Data/glss4_new/data/sec1.dta") %>%
  unite('hh_id', nh, clust) %>%
  mutate('age' = agey,
         'rel_to_hoh' = rel) %>%
  select(hh_id, pid, age, rel_to_hoh)

'Income Code:'
#Income ----

crop_inc <- read_dta("Data/glss4_new/aggregates/inc10.dta") %>%
  unite('hh_id', nh, clust) %>%
  mutate('maincrop_inc' = cropsv1, .keep = 'unused')%>%
  mutate('othercrop_inc' = cropsv2, .keep = 'unused') %>%
  replace(is.na(.), 0) %>%
  group_by(hh_id) %>%
  summarise(crop_inc = sum(maincrop_inc, othercrop_inc))

lvstk_inc <- read_dta("Data/glss4_new/data/sec8a2.dta") %>%
  unite('hh_id', nh, clust) %>%
  mutate('lvstk_inc_sale' = s8aq26, .keep = 'unused')%>%
  mutate('lvstk_inc_rent' = s8aq31, .keep = 'unused') %>%
  replace(is.na(.), 0) %>%
  group_by(hh_id) %>%
  summarise(lvstk_inc = sum(lvstk_inc_sale, lvstk_inc_rent))

otherag_inc<- read_dta("Data/glss4_new/aggregates/inc12.dta")%>%
  unite('hh_id', nh, clust) %>%
  mutate('otherag_inc' = othaginc, .keep = 'unused') %>%
  replace(is.na(.), 0) %>%
  group_by(hh_id) %>%
  summarise(otherag_inc = sum(otherag_inc))

proc_inc <- read_dta("Data/glss4_new/aggregates/inc13.dta")%>%
  unite('hh_id', nh, clust) %>%
  mutate('proc_inc' = inctrcrp, .keep = 'unused') %>%
  replace(is.na(.), 0) %>%
  group_by(hh_id)%>%
  summarise(proc_inc = sum(proc_inc))