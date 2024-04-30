#' @import spotifyr
#' @import dplyr
#' @import usethis
id <- "b6bed725df9a4966a23b8984a2d40457"
secret <- "5609c10a964b4f2082f47842a5d2fc50"

access_token <- spotifyr::get_spotify_access_token(id, secret)
authorization <- spotifyr::get_spotify_authorization_code(id, secret,
  scope = c(
    "user-top-read", "user-read-recently-played",
    "user-read-currently-playing"
  )
)



# Obtain top long_term artists
offset <- seq(0, 950, 50)
top_artists_longterm <- data.frame()
for (batch in offset) {
  curr_artists <- spotifyr::get_my_top_artists_or_tracks(
    type = "artists",
    limit = 50,
    offset = batch,
    time_range = "long_term",
    authorization = authorization
  )
  top_artists_longterm <- dplyr::bind_rows(top_artists_longterm, curr_artists)
}


# Obtain top long_term tracks
top_tracks_longterm <- data.frame()
for (batch in offset) {
  curr_tracks <- spotifyr::get_my_top_artists_or_tracks(
    type = "tracks",
    limit = 50,
    offset = batch,
    time_range = "long_term",
    authorization = authorization
  )
  top_tracks_longterm <- dplyr::bind_rows(top_tracks_longterm, curr_tracks)
}

# offset value
offset_length <- ceiling(spotifyr::get_my_saved_tracks(
  include_meta_info = TRUE,
  authorization = authorization
)[["total"]] / 50)
offset_total <- (seq(offset_length) - 1) * 50

## Obtain saved tracks
saved_tracks <- data.frame()
for (batch in offset_total) {
  curr_saved_tracks <- spotifyr::get_my_saved_tracks(
    limit = 50,
    offset = batch, authorization = authorization
  )
  saved_tracks <- dplyr::bind_rows(saved_tracks, curr_saved_tracks)
}



usethis::use_data(top_artists_longterm, overwrite = TRUE)
usethis::use_data(top_tracks_longterm, overwrite = TRUE)
usethis::use_data(saved_tracks, overwrite = TRUE)

###################################
###################################

# Fetch data using the calculated date range - MEDIUM TERM (approx 6 months)
offset <- seq(0, 950, 50)
top_artists_mediumterm <- data.frame()
for (batch in offset) {
  curr_artists <- spotifyr::get_my_top_artists_or_tracks(
    type = "artists",
    limit = 50,
    offset = batch,
    time_range = "medium_term",
    authorization = authorization
  )
  top_artists_mediumterm <- dplyr::bind_rows(
    top_artists_mediumterm,
    curr_artists
  )
}


# Obtain top medium_term tracks
top_tracks_mediumterm <- data.frame()
for (batch in offset) {
  curr_tracks <- spotifyr::get_my_top_artists_or_tracks(
    type = "tracks",
    limit = 50,
    offset = batch,
    time_range = "medium_term",
    authorization = authorization
  )
  top_tracks_mediumterm <- dplyr::bind_rows(top_tracks_mediumterm, curr_tracks)
}

usethis::use_data(top_artists_mediumterm, overwrite = TRUE)
usethis::use_data(top_tracks_mediumterm, overwrite = TRUE)


###################################

# Fetch data using the calculated date range - SHORT TERM (approx 1 month)
offset <- seq(0, 950, 50)
top_artists_shortterm <- data.frame()
for (batch in offset) {
  curr_artists <- spotifyr::get_my_top_artists_or_tracks(
    type = "artists",
    limit = 50,
    offset = batch,
    time_range = "short_term",
    authorization = authorization
  )
  top_artists_shortterm <- dplyr::bind_rows(top_artists_shortterm, curr_artists)
}


# Obtain top short_term tracks
top_tracks_shortterm <- data.frame()
for (batch in offset) {
  curr_tracks <- spotifyr::get_my_top_artists_or_tracks(
    type = "tracks",
    limit = 50,
    offset = batch,
    time_range = "short_term",
    authorization = authorization
  )
  top_tracks_shortterm <- dplyr::bind_rows(top_tracks_shortterm, curr_tracks)
}

usethis::use_data(top_artists_shortterm, overwrite = TRUE)
usethis::use_data(top_tracks_shortterm, overwrite = TRUE)

###################################
# Saving energy/valence data for top songs
st <- spotifywRapped::saved_tracks

for (i in seq_len(st)) {
  if (i %% 100 == 0) {
    print(paste0("Sleeping... ", i %/% 100))
    Sys.sleep(30)
  }
  track_id <- st$track.id[i]
  track_features <- spotifyr::get_track_audio_features(track_id,
    authorization = access_token
  )
  st$energy[i] <- track_features$energy
  st$valence[i] <- track_features$valence
}

saved_tracks <- st

usethis::use_data(saved_tracks, overwrite = TRUE)


###################################
# Adding artists to long, med, short term, saved tracks
lt_tracks <- spotifywRapped::top_tracks_longterm
mt_tracks <- spotifywRapped::top_tracks_mediumterm
st_tracks <- spotifywRapped::top_tracks_shortterm

sv_tracks <- spotifywRapped::saved_tracks


for (i in seq_len(nrow(sv_tracks))) {
  sv_tracks$artist[i] <- sv_tracks$track.artists[[i]]$name[[1]]
}

for (i in seq_len(nrow(lt_tracks))) {
  lt_tracks$artist[i] <- lt_tracks$artists[[i]]$name[[1]]
}

for (i in seq_len(nrow(mt_tracks))) {
  lt_tracks$artist[i] <- lt_tracks$artists[[i]]$name[[1]]
}

for (i in seq_len(nrow(st_tracks))) {
  lt_tracks$artist[i] <- lt_tracks$artists[[i]]$name[[1]]
}

top_tracks_longterm <- lt_tracks
top_tracks_mediumterm <- mt_tracks
top_tracks_shortterm <- st_tracks
saved_tracks <- sv_tracks

usethis::use_data(top_tracks_longterm, overwrite = TRUE)
usethis::use_data(top_tracks_mediumterm, overwrite = TRUE)
usethis::use_data(top_tracks_shortterm, overwrite = TRUE)
usethis::use_data(saved_tracks, overwrite = TRUE)
