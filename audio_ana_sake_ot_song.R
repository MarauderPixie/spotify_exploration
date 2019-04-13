# Endpoint:
# https://api.spotify.com/v1/audio-analysis/{id}
#
# ID of For The Sake Of The Song:
# 303YuJ9qRGnRIBAdqmn566

## !! the resulting file will have a size of about 4.5mb !!
sake_song <- httr::GET("https://api.spotify.com/v1/audio-analysis/303YuJ9qRGnRIBAdqmn566",
                       httr::config(token = token)) %>%
  httr::content()

sake_song_bars <- map_df(seq_along(sake_song$bars), function(x){
  tibble(
    start = pluck(sake_song, "bars", x, "start", .default = NA),
    dur   = pluck(sake_song, "bars", x, "duration", .default = NA),
    conf  = pluck(sake_song, "bars", x, "confidence", .default = NA)
  )
})

sake_song_beats <- map_df(seq_along(sake_song$beats), function(x){
  tibble(
    start = pluck(sake_song, "beats", x, "start", .default = NA),
    dur   = pluck(sake_song, "beats", x, "duration", .default = NA),
    conf  = pluck(sake_song, "beats", x, "confidence", .default = NA)
  )
})

sake_song_tatums <- map_df(seq_along(sake_song$tatums), function(x){
  tibble(
    start = pluck(sake_song, "tatums", x, "start", .default = NA),
    dur   = pluck(sake_song, "tatums", x, "duration", .default = NA),
    conf  = pluck(sake_song, "tatums", x, "confidence", .default = NA)
  )
})


ss_30_bars <- filter(sake_song_bars, start < 10)
ss_30_beats <- filter(sake_song_beats, start < 10)
ss_30_tatums <- filter(sake_song_tatums, start < 10)

ggplot(data = NULL, aes(start, dur)) + 
  geom_point(data = ss_30_bars, color = "white") +
  geom_point(data = ss_30_beats, color = "red") +
  geom_vline(data = ss_30_beats, aes(xintercept = start), color = "red", alpha = .2) +
  geom_point(data = ss_30_tatums)
