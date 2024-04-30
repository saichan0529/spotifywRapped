#' Artist Frequency Bar Graph
#'
#' Create a bar graph demonstrating the top 10 artists, and how many songs of
#'   each artist.
#'
#' @param dataset A data frame containing the user's saved or top tracks.
#'   Defaults to package data.
#' @param category A character string specifying whether the tracks come from
#'   the saved or top tracks.
#' @param vibe A character string specifying the vibe of the graphic. Must be
#'   one of "bright", "dark", "neon", or "soft".
#' @param name A character string specifying the name of the graphic.
#' @param saveto A character string specifying the directory where the graphic
#'   should be saved. Defaults to the current working directory.
#'
#' @import ggplot2
#' @import forcats
#' @importFrom cowplot ggdraw draw_image draw_plot
#' @importFrom grid textGrob gpar
#' @importFrom grDevices png dev.off
#' @importFrom graphics par text
#' @importFrom stats reorder
#' @importFrom utils head
#'
#' @return The file path of the .png file.
#' @export
my_artist_frequency <- function(dataset = data.frame(),
                                category = "saved",
                                vibe = "neon",
                                name = "artist_frequency",
                                saveto = getwd()) {
  # file set-up
  file_name <- file.path(saveto, paste0(name, ".png"))

  # choose dataset
  if (length(dataset) == 0) {
    if (category == "top") {
      dataset <- spotifywRapped::top_tracks_longterm
    } else {
      dataset <- spotifywRapped::saved_tracks
    }
  }



  # arranging data
  occurences <- table(unlist(dataset$artist))
  df <- as.data.frame(occurences)
  data_sorted <- df[order(df$Freq, decreasing = TRUE), ]

  new_df <- head(data_sorted, 10)
  new_df$Var1 <- factor(new_df$Var1,
    levels =
      new_df$Var1[order(new_df$Freq, decreasing = TRUE)],
    ordered = TRUE
  )


  top_artist <- new_df$Var1[new_df$Freq == max(new_df$Freq)]
  number_song <- new_df$Freq[new_df$Var1 == top_artist]

  # color palette
  palette <- color_palette(vibe)
  bar_color <- palette[1]
  background_color <- palette[2]
  text_line_color <- palette[3]

  # get background image
  background_image <- system.file("vibes",
    paste0(
      "frequency_",
      category, "_", vibe, ".png"
    ),
    package = "spotifywRapped"
  )



  # plot set-up
  y_max <- ceiling(max(new_df$Freq) / 5) * 5
  new_df$Var1 <- as.character(new_df$Var1)
  for (i in seq_along(new_df$Var1)) {
    if (!is.na(new_df$Var1[i]) && nchar(new_df$Var1[i]) > 20) {
      new_label <- paste0(substr(new_df$Var1[i], 1, 20), "...")
      new_df$Var1[i] <- new_label
    }
  }

  # plot
  artist_frequency_plot <- ggplot2::ggplot(
    data = new_df,
    ggplot2::aes(
      x = .data$Var1,
      y = .data$Freq
    )
  ) +
    ggplot2::geom_bar(stat = "identity", fill = bar_color) +
    ggplot2::geom_text(aes(label = .data$Var1),
      vjust = -1, hjust = 0,
      color = text_line_color,
      size = 8,
      angle = 30,
      position = position_nudge(x = -0.25)
    ) +
    ggplot2::scale_x_discrete(
      labels = NULL,
      breaks = NULL,
      expand = expansion(add = c(0.75, 3))
    ) +
    ggplot2::scale_y_continuous(
      breaks = seq(0, y_max, 5),
      limits = c(0, y_max),
      expand = expansion(add = c(0, 10))
    ) +
    ggplot2::labs(x = "", y = "") +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.margin = ggplot2::margin(388, 128, 705, 125, "points"),
      plot.background = ggplot2::element_rect(
        fill = "transparent",
        color = NA
      ),
      panel.background = ggplot2::element_rect(
        fill = background_color
      )
    ) +
    ggplot2::theme(
      axis.line = element_line(color = bar_color),
      axis.line.x = element_blank(),
      axis.text = element_text(color = bar_color, size = 25),
      panel.grid.major = element_line(
        color = bar_color,
        linetype = "dotted"
      ),
      panel.grid.minor = element_line(
        color = bar_color,
        linetype = "dotted"
      )
    ) +
    ggplot2::coord_cartesian(ylim = c(0, y_max), xlim = c(1, 11))

  # arrange file
  png(filename = file_name, width = 1080, height = 1920, units = "px")
  print(
    cowplot::ggdraw() +
      cowplot::draw_image(background_image) +
      cowplot::draw_plot(artist_frequency_plot) +
      cowplot::draw_text(top_artist,
        y = 0.225,
        color = text_line_color,
        size = 60
      ) +
      cowplot::draw_text(number_song,
        y = 0.125,
        color = text_line_color,
        size = 60
      )
  )
  dev.off()
  return(file_name)
}


color_palette <- function(vibe) {
  # color palette
  if (vibe == "soft") {
    bar_color <- "#66545e"
    background_color <- "white"
    text_line_color <- "black"
  } else if (vibe == "neutral") {
    bar_color <- "#664228"
    background_color <- "white"
    text_line_color <- "black"
  } else if (vibe == "neon") {
    bar_color <- "#00fb35"
    background_color <- "black"
    text_line_color <- "white"
  } else if (vibe == "bright") {
    bar_color <- "#42a593"
    background_color <- "#1e1d1d"
    text_line_color <- "white"
  }

  palette <- c(bar_color, background_color, text_line_color)
  return(palette)
}

artist_frequency_verification <- function(category, vibe) {
  # check inputs
  stopifnot(category == "saved" || category == "top")
  stopifnot(vibe == "soft" || vibe == "neutral" || vibe == "neon" ||
              vibe == "bright")
}
