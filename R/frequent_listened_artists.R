#' Generate a Frequent Listened Artists' Name plot based on Spotify data
#'
#' @param category Character string indicating the category for the data. Must
#'  be one of "long" or "saved". Default is "saved."
#' @param data Character string indicating the type of Spotify data to use.
#'  Can be "long" for long-term top tracks or "saved" for saved tracks.
#' @param vibe Character string indicating the vibe of the word cloud.
#'  Can be one of "bright", "neutral", "neon", or "soft".
#' @param name Character string indicating the name of the output file.
#' @param saveto Character string indicating the directory to save the output
#'  file.
#'
#' @return A character string indicating the path to the saved word cloud image.
#'
#' @importFrom htmlwidgets saveWidget
#' @importFrom webshot webshot
#' @importFrom magick image_read image_crop
#' @importFrom cowplot ggdraw draw_image
#' @importFrom utils head
#'
#' @export
frequent_listened_artists <- function(category = "saved",
                                      data = spotifywRapped::saved_tracks,
                                      vibe = "neon",
                                      name = "untitled", saveto = getwd()) {
  # Check argument types
  if (!is.character(vibe) || !is.character(name) || !is.character(category)) {
    stop("name, category, and vibe must be character strings")
  }

  # Check if vibe argument is valid
  if (!(vibe %in% c("bright", "neutral", "neon", "soft"))) {
    stop("vibe must be one of 'bright', 'neutral', 'neon', or 'soft'")
  }

  # Check if category argument is valid
  if (!(category %in% c("long", "saved"))) {
    stop("category must be one of 'long' or 'saved'")
  }

  # Check if name is empty
  if (name == "") {
    warning("name cannot be an empty string, defaulted to 'untitled'")
  }

  # Select data based on category
  if (category == "long") {
    data <- spotifywRapped::top_tracks_longterm
    artist_names <- vector("list", length = nrow(data))
    for (i in seq_len(nrow(data))) {
      artist_names[[i]] <- data$artists[[i]]$name
    }

    # Define background images
    background_image <- list(
      "soft" = system.file("vibes", "wordcloud_top_soft.png",
        package = "spotifywRapped"
      ),
      "neutral" = system.file("vibes", "wordcloud_top_neutral.png",
        package = "spotifywRapped"
      ),
      "neon" = system.file("vibes", "wordcloud_top_neon.png",
        package = "spotifywRapped"
      ),
      "bright" = system.file("vibes", "wordcloud_top_bright.png",
        package = "spotifywRapped"
      )
    )
  } else {
    data <- spotifywRapped::saved_tracks
    artist_names <- vector("list", length = nrow(data))
    for (i in seq_len(nrow(data))) {
      artist_names[[i]] <- data$artist[i]
    }
    # Define background images
    background_image <- list(
      "soft" = system.file("vibes", "wordcloud_saved_soft.png",
        package = "spotifywRapped"
      ),
      "neutral" = system.file("vibes", "wordcloud_saved_neutral.png",
        package = "spotifywRapped"
      ),
      "neon" = system.file("vibes", "wordcloud_saved_neon.png",
        package = "spotifywRapped"
      ),
      "bright" = system.file("vibes", "wordcloud_saved_bright.png",
        package = "spotifywRapped"
      )
    )
  }

  # Define file path for the output image
  file_name <- file.path(saveto, paste0(name, ".png"))

  # Get artist frequencies
  artist_freq <- as.data.frame(table(unlist(artist_names)))
  colnames(artist_freq) <- c("name", "freq")
  artist_freq <- artist_freq[order(-artist_freq$freq), ]

  # Define color schemes
  vibe_colors <- list(
    "soft" = c("#66545e", "#eda990", "#aa6f73", "#a39193", "#f6e0b5"),
    "neon" = c("#00fb35", "#e5ff04", "#ffac09", "#f80063", "#00ffff"),
    "neutral" = c("#e6d3b3", "#d1b48c", "#ba9976", "#987555", "#664228"),
    "bright" = c("#2c3e50", "#42a593", "#537ea2", "#9f1b1a", "#e58406")
  )

  # Define background colors
  background <- list(
    "soft" = "white",
    "neon" = "black",
    "neutral" = "white",
    "bright" = "#1e1d1d"
  )

  # Select colors and background based on vibe
  colors <- vibe_colors[[vibe]]
  color_vector <- rep(colors, length.out = nrow(artist_freq))

  # Create word cloud
  wordcloud <- wordcloud2::wordcloud2(artist_freq,
    color = color_vector,
    shape = "cardioid", size = .2,
    backgroundColor = background[[vibe]]
  )

  # Save word cloud as HTML file
  wordcloud_html_file <- tempfile(
    pattern = "file", tmpdir = tempdir(),
    fileext = ".html"
  )
  htmlwidgets::saveWidget(wordcloud, wordcloud_html_file, selfcontained = FALSE)

  # Capture word cloud as PNG
  wordcloud_png_file <- tempfile(
    pattern = "file", tmpdir = tempdir(),
    fileext = ".png"
  )
  webshot::webshot(wordcloud_html_file,
    wordcloud_png_file,
    vwidth = 1080,
    vheight = 1920,
    delay = 1
  )

  # Read the captured PNG image
  image <- magick::image_read(wordcloud_png_file)

  # Crop the image to the desired region
  cropped_image <- magick::image_crop(image, geometry = "420x250+315+880")

  # Save the cropped image
  png(filename = file_name, width = 1080, height = 1920, units = "px")
  print(cowplot::ggdraw() + cowplot::draw_image(background_image[[vibe]]) +
          cowplot::draw_image(cropped_image))
  dev.off()

  # Return the file path of the saved image
  return(file_name)
}
