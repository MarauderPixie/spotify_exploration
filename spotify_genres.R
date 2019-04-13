genres <- top50 %>% 
  gather(genre_rank, genre, starts_with("genre"))

genre_count <- genres %>% 
  count(genre)

genres_simplified <- genres %>% 
  mutate(
    # note: order of str_detection changes counts dramatically!
    s_genres = case_when(str_detect(genre, "alternative") ~ "Alternative",
                         str_detect(genre, "rock") ~ "Rock",
                         str_detect(genre, "metal") ~ "Metal",
                         str_detect(genre, "pop") ~ "Pop",
                         str_detect(genre, "punk") ~ "Punk",
                         TRUE ~ NA_character_)
  ) %>% 
  select(-genre) %>% 
  spread(genre_rank, s_genres)


genres_max <- genres_simplified %>% 
  drop_na() %>% 
  group_by(artist) %>% 
  count(s_genres) %>% 
  filter(n == max(n))
