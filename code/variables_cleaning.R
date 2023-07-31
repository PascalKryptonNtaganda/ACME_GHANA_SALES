'Variables Code:'
#Variables ----

eco_zone <- read_dta("Data/glss4_new/data/sec0a.dta")%>%
  unite('hh_id', nh, clust)%>%
  rename("urban" = "loc2") %>%
  mutate(urban = replace(urban, urban == 2, 0),
         "coastal" = ifelse(ez == 1, "1", 0),
         "forest" = ifelse(ez == 2, "1", 0),
         "savannah" = ifelse(ez == 3, "1", 0)) %>%
  inner_join(roster, by = 'hh_id') %>%
  filter(rel_to_hoh == 1) %>%
  select(hh_id, urban, coastal, forest, savannah)

demog <- read_dta("Data/glss4_new/data/sec1.dta") %>%
  unite('hh_id', nh, clust) %>%
  rename("relig" = "s1q9",
         "ecowas" = "s1q11",
         "male" = "sex",
         "married" = "mar",
         "age" = "agey")%>%
  mutate(male = replace(male, male == 2, 0),
         ecowas = replace(ecowas, ecowas < 8, 1),
         ecowas = replace(ecowas, ecowas >= 8, 0),
         married = replace(married, married != 1, 0),
         relig = replace(relig, relig < 10, 1),
         relig = replace(relig, relig == 8, 2),
         relig = replace(relig, relig == 9, 3),
         relig = replace(relig, relig == 10, 0),) %>%
  filter(relig < 4,
         ecowas < 2) %>%
  select(hh_id, pid, relig, ecowas, male, married, age)

education <- read_dta("Data/glss4_new/data/sec2a.dta") %>%
  unite('hh_id', nh, clust) %>%
  mutate("educyrs" = s2aq2,
         "everschool" = s2aq1) %>%
  mutate(educyrs = ifelse(everschool == 2, 0, educyrs)) %>%
  inner_join(roster) %>%
  filter(rel_to_hoh <= 2,
         educyrs < 50,
         age >= 15) %>%
  select(hh_id, pid, rel_to_hoh, age, educyrs)

literacy <- read_dta("Data/glss4_new/data/sec2c.dta") %>%
  unite('hh_id', nh, clust)%>%
  mutate("read_gha" = s2cq2,
         "read_eng" = s2cq1)%>%
  mutate(read_gha = replace(read_gha, read_gha == 1, 0),
         read_gha = replace(read_gha, read_gha > 1, 1),
         read_eng = replace(read_eng, read_eng == 2, 0)) %>%
  inner_join(roster) %>%
  select(hh_id, pid, age, read_gha, read_eng)

educ_lit <- merge(education, literacy)

rm(education, literacy)

water <- read_dta("Data/glss4_new/data/sec7.dta") %>%
  unite('hh_id', nh, clust) %>%
  mutate("water_dist" = s7dq2a) %>%
  mutate("meas" = s7dq2b) %>%
  mutate(water_dist = ifelse(meas == 1, water_dist*0.9144, water_dist),
         water_dist = ifelse(meas == 3, water_dist*1000, water_dist),
         water_dist = ifelse(meas == 4, water_dist*1609.34, water_dist))%>%
  transform(water_dist = as.integer(water_dist))%>%
  rename("water_dist_m" = "water_dist")%>%
  select(hh_id, water_dist_m)

gen_wealth <- read_dta("Data/glss4_new/data/sec4f.dta") %>%
  unite('hh_id', nh, clust) %>%
  mutate("fund_source" = s4fq14,
         fund_source = replace(fund_source, fund_source > 1, 0)) %>%
  drop_na(fund_source) %>%
  inner_join(roster) %>%
  select(hh_id, pid, rel_to_hoh, fund_source)

variables <- roster %>%
  full_join(demog) %>%
  full_join(eco_zone)%>%
  full_join(educ_lit)%>%
  full_join(gen_wealth)%>%
  full_join(water)
