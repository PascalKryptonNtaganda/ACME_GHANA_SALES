'Expenditure Code:'
#Expenditure: ----
crop_exp_df <- read_dta("Data/glss4_new/data/sec8f.dta")

crop_exp <- select(crop_exp_df, nh, clust, crpexpcd, s8fq2) %>%
  unite('hh_id', nh, clust) %>%
  mutate('crop_exp' = s8fq2, .keep = 'unused') %>%
  replace(is.na(.), 0) %>%
  filter(crop_exp > 0) %>%
  group_by(hh_id) %>%
  summarise(crop_exp = sum(crop_exp))

rm(crop_exp_df)

land_exp_df <- read_dta("Data/glss4_new/aggregates/exp3.dta")

land_exp <- select(land_exp_df, nh, clust, landexp) %>%
  unite('hh_id', nh, clust) %>%
  mutate('land_rent_exp' = as.numeric(round(landexp, digits = 2)),
         .keep = 'unused') %>%
  replace(is.na(.), 0) %>%
  filter(land_rent_exp > 0) %>%
  group_by(hh_id) %>%
  summarise(land_rent_exp = sum(land_rent_exp))

rm(land_exp_df)

livest_exp_df <- read_dta("Data/glss4_new/aggregates/exp5.dta")

livest_exp <- select(livest_exp_df, nh, clust, livexp) %>%
  unite('hh_id', nh, clust) %>%
  mutate('livestock_exp' = round(livexp, digits = 2),
         .keep = 'unused') %>%
  replace(is.na(.), 0) %>%
  filter(livestock_exp > 0) %>%
  group_by(hh_id) %>%
  summarise(livestock_exp = sum(livestock_exp))

rm(livest_exp_df)

proc_exp_df <- read_dta("Data/glss4_new/aggregates/exp6.dta")

proc_exp <- select(proc_exp_df, nh, clust, fdprexp1,
                   fdprexp2) %>%
  unite('hh_id', nh, clust) %>%
  mutate('proc_exp' = round(fdprexp1 + fdprexp2, digits = 2)) %>%
  replace(is.na(.), 0) %>%
  filter(proc_exp > 0) %>%
  group_by(hh_id) %>%
  summarise(proc_exp = sum(proc_exp))

rm(proc_exp_df)

home_cons_df <- read_dta("Data/glss4_new/aggregates/exp7.dta")

home_cons <- select(home_cons_df, nh, clust, hp) %>%
  unite('hh_id', nh, clust) %>%
  mutate('home_cons' = round(hp, digits = 2)) %>%
  replace(is.na(.), 0) %>%
  filter(home_cons > 0) %>%
  group_by(hh_id) %>%
  summarise(home_cons = sum(home_cons))

rm(home_cons_df)

total_exp <- crop_exp %>%
  full_join(home_cons, by = 'hh_id') %>%
  full_join(land_exp, by = 'hh_id') %>%
  full_join(livest_exp, by = 'hh_id') %>%
  full_join(proc_exp, by = 'hh_id') %>%
  replace(is.na(.), 0) %>%
  mutate('total_exp' = crop_exp + home_cons + land_rent_exp +
           livestock_exp + proc_exp)
