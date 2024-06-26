% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{top_artists_longterm}
\alias{top_artists_longterm}
\title{Top Artists - Longterm}
\format{
\subsection{\code{top_artists_longterm}}{

A data frame with 133 rows and 11 columns:
\describe{
\item{name}{Artist's name, character}
\item{id}{Artist's unique Spotify ID, character}
\item{images}{Artist's photo URLs as a dataframe. Different size options
available}
\item{genres}{Artist's tracks' genres, stored as list}
...
}
}
}
\source{
\url{https://developer.spotify.com/documentation/web-api/reference/get-users-top-artists-and-tracks}
}
\usage{
top_artists_longterm
}
\description{
Top / most-played of Jared Hileman's Spotify artists pulled from
approximately April 23rd, 2023 - April 23th, 2024
(around 1 year -- limit: 1000 observations).
}
\keyword{datasets}
