# Endpoint:
# https://api.spotify.com/v1/audio-analysis/{id}
#
# ID of Melody Lane:
# 5bgAHjvbNuUg5djUGjUiTW


## !! the resulting file will have a size of about 4.5mb !!
mel_lane <- httr::GET("https://api.spotify.com/v1/audio-analysis/5bgAHjvbNuUg5djUGjUiTW",
                      httr::config(token = token)) %>%
  httr::content()

mal_lane_bars <- map_df(seq_along(mel_lane$bars), function(x){
  tibble(
    start = pluck(mel_lane, "bars", x, "start", .default = NA),
    dur   = pluck(mel_lane, "bars", x, "duration", .default = NA),
    conf  = pluck(mel_lane, "bars", x, "confidence", .default = NA)
  )
})

mal_lane_beats <- map_df(seq_along(mel_lane$beats), function(x){
  tibble(
    start = pluck(mel_lane, "beats", x, "start", .default = NA),
    dur   = pluck(mel_lane, "beats", x, "duration", .default = NA),
    conf  = pluck(mel_lane, "beats", x, "confidence", .default = NA)
  )
})

mal_lane_tatums <- map_df(seq_along(mel_lane$tatums), function(x){
  tibble(
    start = pluck(mel_lane, "tatums", x, "start", .default = NA),
    dur   = pluck(mel_lane, "tatums", x, "duration", .default = NA),
    conf  = pluck(mel_lane, "tatums", x, "confidence", .default = NA)
  )
})
