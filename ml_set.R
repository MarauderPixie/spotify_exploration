art_count <- t50f %>% 
  count(artist_id) %>% 
  filter(n > 100)

ml_set <- t50f %>% 
  filter(artist_id %in% art_count$artist_id) %>% 
  group_by(artist_id) %>% 
  sample_n(100) %>% 
  ungroup()


# rather clumsy test/train split...
ml_valid <- ml_set %>% 
  group_by(artist) %>% 
  sample_frac(.15)

ml_train <- anti_join(ml_set, ml_valid, by = "track_id") %>% 
  select(artist, dur_ms, popularity, 11:21) %>% 
  mutate(
    artist_num = as.numeric(factor(artist)) - 1
  )

ml_valid <- ml_valid %>% 
  select(artist, dur_ms, popularity, 11:21) %>% 
  mutate(
    artist_num = as.numeric(factor(artist)) - 1
  )

## sa to csv
write_csv(ml_set, "data/ml_set_full.csv")
write_csv(ml_train, "data/ml_train.csv")
write_csv(ml_valid, "data/ml_valid.csv")



## keep this for now
# ml_set_rdy <- ml_set %>% 
#   select(artist, dur_ms, popularity, 11:21) %>% 
#   mutate(
#     artist_num = as.numeric(factor(artist)) - 1
#   )
# 
# write_csv(ml_set_rdy, "data/ml_set_ready.csv")
