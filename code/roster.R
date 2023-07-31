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
