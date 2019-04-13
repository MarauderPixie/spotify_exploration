ml_set <- t50f %>% 
  filter(artist_id %in% art_count$artist_id) %>% 
  group_by(artist_id) %>% 
  sample_n(100) %>% 
  ungroup()

write_csv(ml_set, "data/ml_set_full.csv")

ml_set_rdy <- ml_set %>% 
  select(artist, dur_ms, popularity, 11:21) %>% 
  mutate(
    artist_num = as.numeric(factor(artist)) - 1
  )

write_csv(ml_set_rdy, "data/ml_set_ready.csv")