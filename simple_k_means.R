## get some data first
top50 <- get_user_toplist(time_range = "long_term", n = 50, token = token) %>% 
  tidy_artists()

t50_albums <- get_artists_albums(top50$artist_id, token = token) %>% 
  tidy_albums()

t50_tracks <- get_tracks(t50_albums$track_ids, token = token) %>% 
  tidy_tracks()

t50f <- get_track_features(t50_tracks$track_id, token = token) %>% 
  tidy_track_features()

rm(t50_albums, t50_tracks) # we don't need these anymore


# prepare data
replic <- t50f %>% 
  select_if(is.numeric) %>% 
  select(-track_no, -popularity, -loudness, -time_signature, -key, -mode) %>% 
  scale() %>% 
  as_tibble() %>% 
  rowid_to_column("id") %>% 
  gather(feat, wert, -id) %>% 
  filter(between(wert, -2.5, 2.5)) %>% 
  mutate(wert = scales::rescale(wert, c(0, 1))) %>% 
  spread(feat, wert) %>% 
  drop_na() %>% 
  select(-id)


## simple pca maybe?
# sjt.pca(replic[-6], show.msa = TRUE, show.var = TRUE)


## "explorative" cluster analysis
map_df(1:18, function(x){
  k <- kmeans(replic, x)
  
  tibble(
    n_cluster = x,
    witihn_ss = k$tot.withinss
  )
}) %>% 
  ggplot(aes(n_cluster, witihn_ss)) +
    geom_line() +
    geom_point() +
    labs(subtitle = "less within_ss = more variance explained")

# let's stick with 5 clusters for now:
rep_cluster <- kmeans(replic, 5)

# back to more k-meaning!
rep_cluster$centers %>% 
  as_tibble() %>% 
  rowid_to_column("k_lab") %>% 
  gather(feature, fmean, -k_lab) %>% 
  ggplot(aes(y = feature, x = as.factor(k_lab), fill = fmean)) +
    geom_tile(size = .5) +
    geom_label(aes(label = round(fmean, 3)), color = "white", alpha = 0) +
    labs(y = "features", x = "Centroids / 'factors' in pca", fill = "k-means")

# visualize, I guess?
sjt.pca(replic, nmbr.fctr = 2)

km_pca <- replic %>% 
  mutate(
    pc1 = ((1-acousticness) + energy + liveness + speechiness + tempo) / 5,
    pc2 = ((1-acousticness) + dur_ms + instrumentalness + (1-valence)) / 4,
    km  = as.factor(rep_cluster$cluster)
  )

ggplot(km_pca, aes(pc1, pc2, color = km)) +
  geom_point()
