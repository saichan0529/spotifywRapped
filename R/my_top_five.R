#' Visualize your top five artists or tracks
#'
#' This function creates a visualization of a user's top five artists or tracks
#' based on the vibe specified and whether the data is long-term, medium-term,
#' or short-term (all time, last 6 months, last 4 weeks, respectively).
#' The user specifies both the name and storage location of the graphic, which
#' is saved as a .png file.
#'
#' @param name A character string specifying the name of the graphic.
#' @param saveto A character string specifying the directory where the graphic
#' should be saved. Defaults to the current working directory.
#' @param time A character string specifying the time frame for the data. Must
#' be one of "long", "medium", or "short".
#' @param vibe A character string specifying the vibe of the graphic. Must be
#' one of "bright", "neutral", "neon", or "soft".
#' @param category A character string specifying whether the data is for artists
#'  or
#' tracks. Must be one of "artists" or "songs".
#' @param dataset A data frame containing the user's top artists or tracks.
#' Defaults to package data.
#' @return The file path of the .png file.
#'
#'
#' @import magick
#' @import dplyr
#' @export
my_top_five <- function(time, vibe, category = "artists", name = "my_top_five",
                        saveto = getwd(), dataset = data.frame()) {
  my_top_five_validation(time, vibe, category, name, saveto, dataset)

  background_relative <- paste0(category, "_", time, "_", vibe, ".png")
  background_path <- system.file("vibes", background_relative,
    package = "spotifywRapped"
  )

  background <- magick::image_read(background_path)
  if (length(dataset) == 0) {
    if (category == "artists") {
      if (time == "long") {
        dataset <- spotifywRapped::top_artists_longterm
      } else if (time == "medium") {
        dataset <- spotifywRapped::top_artists_mediumterm
      } else if (time == "short") {
        dataset <- spotifywRapped::top_artists_shortterm
      }
      image_url <- dataset$images[1][[1]]$url[[1]]
    } else {
      if (time == "long") {
        dataset <- spotifywRapped::top_tracks_longterm
      } else if (time == "medium") {
        dataset <- spotifywRapped::top_tracks_mediumterm
      } else if (time == "short") {
        dataset <- spotifywRapped::top_tracks_shortterm
      }
      image_url <- dataset$album.images[1][[1]]$url[[1]]
    }
  }

  mini_image <- magick::image_read(image_url)
  mini_image <- magick::image_resize(mini_image, "530x530")
  names <- dataset$name[2:5]
  if (any(is.na(names))) {
    names[is.na(names)] <- ""
  }

  box_coordinates <- data.frame(
    x = rep(400, times = 4) / 1080,
    y = (1920 - c(1140, 1270, 1400, 1530) - 42) / 1920,
    label = names
  )

  file_name <- paste0(name, ".png")
  postables_path <- file.path(saveto, file_name)

  generate_image(
    postables_path, background, mini_image, vibe, dataset,
    box_coordinates
  )

  return(postables_path)
}



my_top_five_validation <- function(time, vibe, category = "artists",
                                   name, saveto, dataset) {
  if (!is.character(time) || !is.character(vibe) || !is.character(category) ||
      !is.character(name)
  ) {
    stop("name, time, vibe, and category must be character strings")
  }

  if (!(time %in% c("long", "medium", "short"))) {
    stop("time must be one of 'long', 'medium', or 'short'")
  }

  if (!(category %in% c("artists", "songs"))) {
    stop("category must be one of 'artists' or 'songs'")
  }

  if (!(vibe %in% c("bright", "neutral", "neon", "soft"))) {
    stop("vibe must be one of 'bright', 'neutral', 'neon', or 'soft'")
  }
}


# Helper function to handle image generation
generate_image <- function(postables_path, background, mini_image, vibe,
                           dataset, coordinates) {
  png(postables_path, width = 1080, height = 1920)


  bck <- "white"
  if (vibe == "neon") {
    bck <- "black"
  } else if (vibe == "bright") {
    bck <- "#1e1d1d"
  }

  par(bg = bck, mar = c(0, 0, 0, 0))

  plot(0,
    type = "n", xlim = c(0, 1), ylim = c(0, 1), xaxt = "n", yaxt = "n",
    xlab = "", ylab = "", main = "", bty = "n", ann = FALSE
  )

  for (label in coordinates$label) {
    if (nchar(label) > 30) {
      new_label <- paste0(substr(label, 1, 30), "...")
      coordinates$label[coordinates$label == label] <- new_label
    }
  }
  # Overlay the raster image
  graphics::rasterImage(background, 0, 0, 1, 1)
  graphics::rasterImage(
    mini_image, 275 / 1080, (1920 - 530 - 500) / 1920,
    (275 + 530) / 1080,
    (1920 - 500) / 1920
  )
  textcolor <- ifelse(vibe == "bright" || vibe == "neon", "white", "black")
  text(
    x = (190 + 350) / 1080, y = (1920 - 350) / 1920,
    labels = dataset$name[1], col = textcolor, cex = 3, adj = 0.5
  )
  text(
    x = coordinates$x, y = coordinates$y,
    labels = coordinates$label, col = textcolor, cex = 3, adj = 0
  )

  # Close the graphics device
  dev.off()
}
