#' Top Tracks - Shortterm
#'
#' Top / most-played of Jared Hileman's Spotify tracks pulled from approximately
#'  March 26th, 2024 - April 28th, 2024 (around 4 weeks).
#'
#' @format ## `top_tracks_shortterm`
#' A data frame with 69 rows and 29 columns:
#' \describe{
#'   \item{artists}{Dataframe containing artist(s) name, ID, and photo URLs}
#'   \item{available_markets}{Countries in which song is availabe}
#'   \item{id}{Track's unique Spotify ID. Can be used to access track audio
#'   features. Character.}
#'   \item{name}{Track title}
#'   \item{album.images}{Album cover image URL(s) to which the track belongs}
#'   ...
#' }
#' @source <https://developer.spotify.com/documentation/web-api/reference/get-users-top-artists-and-tracks>
"top_tracks_shortterm"

#' Top Tracks - Mediumterm
#'
#' Top / most-played of Jared Hileman's Spotify tracks pulled from approximately
#' October 23rd, 2023 - April 23th, 2024 (around 6 months).
#'
#' @format ## `top_tracks_mediumterm`
#' A data frame with 846 rows and 29 columns:
#' \describe{
#'   \item{artists}{Dataframe containing artist(s) name, ID, and photo URLs}
#'   \item{available_markets}{Countries in which song is availabe}
#'   \item{id}{Track's unique Spotify ID. Can be used to access track audio
#'   features. Character.}
#'   \item{name}{Track title}
#'   \item{album.images}{Album cover image URL(s) to which the track belongs}
#'   ...
#' }
#' @source <https://developer.spotify.com/documentation/web-api/reference/get-users-top-artists-and-tracks>
"top_tracks_mediumterm"

#' Top Tracks - Longterm
#'
#' Top / most-played of Jared Hileman's Spotify tracks pulled from approximately
#' April 23rd, 2023 - April 23th, 2024 (around 1 year -- limit: 1000
#' observations).
#'
#' @format ## `top_tracks_longterm`
#' A data frame with 1000 rows and 29 columns:
#' \describe{
#'   \item{artists}{Dataframe containing artist(s) name, ID, and photo URLs}
#'   \item{available_markets}{Countries in which song is availabe}
#'   \item{id}{Track's unique Spotify ID. Can be used to access track audio
#'   features. Character}
#'   \item{name}{Track title}
#'   \item{album.images}{Album cover image URL(s) to which the track belongs}
#'   ...
#' }
#' @source <https://developer.spotify.com/documentation/web-api/reference/get-users-top-artists-and-tracks>
"top_tracks_longterm"


#' Top Artists - Shortterm
#'
#' Top / most-played of Jared Hileman's Spotify artists pulled from
#' approximately March 26th, 2024 - April 28th, 2024 (around 4 weeks).
#'
#' @format ## `top_artists_shortterm`
#' A data frame with 4 rows and 11 columns:
#' \describe{
#'   \item{name}{Artist's name, character}
#'   \item{id}{Artist's unique Spotify ID, character}
#'   \item{images}{Artist's photo URLs as a dataframe. Different size options
#'   available}
#'   \item{genres}{Artist's tracks' genres, stored as list}
#'   ...
#' }
#' @source <https://developer.spotify.com/documentation/web-api/reference/get-users-top-artists-and-tracks>
"top_artists_shortterm"

#' Top Artists - Mediumterm
#'
#' Top / most-played of Jared Hileman's Spotify artists pulled from
#' approximately March 26th, 2024 - April 28th, 2024 (around 4 weeks).
#'
#' @format ## `top_artists_mediumterm`
#' A data frame with 56 rows and 11 columns:
#' \describe{
#'   \item{name}{Artist's name, character}
#'   \item{id}{Artist's unique Spotify ID, character}
#'   \item{images}{Artist's photo URLs as a dataframe. Different size options
#'   available}
#'   \item{genres}{Artist's tracks' genres, stored as list}
#'   ...
#' }
#' @source <https://developer.spotify.com/documentation/web-api/reference/get-users-top-artists-and-tracks>
"top_artists_mediumterm"

#' Top Artists - Longterm
#'
#' Top / most-played of Jared Hileman's Spotify artists pulled from
#' approximately April 23rd, 2023 - April 23th, 2024
#' (around 1 year -- limit: 1000 observations).
#'
#' @format ## `top_artists_longterm`
#' A data frame with 133 rows and 11 columns:
#' \describe{
#'   \item{name}{Artist's name, character}
#'   \item{id}{Artist's unique Spotify ID, character}
#'   \item{images}{Artist's photo URLs as a dataframe. Different size options
#'   available}
#'   \item{genres}{Artist's tracks' genres, stored as list}
#'   ...
#' }
#' @source <https://developer.spotify.com/documentation/web-api/reference/get-users-top-artists-and-tracks>
"top_artists_longterm"


#' Saved Tracks - All time
#'
#' All of Jared Hileman's saved Spotify tracks.
#'
#' @format ## `saved_tracks`
#' A dataframe with 765 rows and 33 columns:
#'
#' \describe{
#'  \item{track.artists}{List of dataframes containing artist(s) name, ID, and
#'  photo URLs}
#'  \item{track.id}{Track's unique Spotify ID.
#'  Can be used to access track audio. Character.}
#'  \item{track.name}{Track title. Character.}
#'  \item{artist}{Principal artist on the track. Not natively pulled from
#'  API--reference `DATASET.R` to view code to add this column. Character.}
#'  \item{energy}{Audio feature called 'energy' of the track. Not natively
#'  pulled from API--reference `DATASET.R` to view code to add this column.
#'  Numeric.}
#'  \item{valence}{Audio feature called 'acousticness' of the track. Not
#'  natively pulled from API--reference `DATASET.R` to view code to add this
#'  column. Numeric.}
#'  ...
#'  }
#'  @source <https://developer.spotify.com/documentation/web-api/reference/get-users-saved-tracks>
"saved_tracks"
