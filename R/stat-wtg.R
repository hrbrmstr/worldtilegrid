#' @rdname geom_wtg
#' @export
stat_wtg <- function(mapping = NULL, data = NULL, na.rm = NA, show.legend = NA,
                     inherit.aes = TRUE, ...) {

  layer(
    stat = StatWtg,
    data = data,
    mapping = mapping,
    geom = "wtg",
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname geom_wtg
#' @export
StatWtg <- ggproto(
  `_class` = "StatWtg",
  `_inherit` = ggplot2::Stat,

  required_aes = c("country", "fill"),

  compute_layer = function(data, params, layout) {

    data <- data[!sapply(data$country, is.na),]

    p <- split(data, data$PANEL)

    if (max(nchar(data[["country"]])) == 3) {
      merge.x <- "alpha.3"
    } else if (max(nchar(data[["country"]])) == 2) {
      merge.x <- "alpha.2"
    } else {
      merge.x <- "name"
    }

    lapply(p, function(.x) {

      has <- unique(.x$country)
      has_not <- setdiff(wtg[[merge.x]], has)

      if (length(has_not) > 0) {

        data.frame(
          fill = NA,
          country = has_not,
          PANEL = .x$PANEL[1],
          group = NA,
          stringsAsFactors = FALSE
        ) -> to_bind

        .x <- rbind.data.frame(.x, to_bind)

      }

      merge(.x, wtg, by.x="country", by.y=merge.x)

    }) -> p

    if (length(p) > 1) {
      do.call(rbind.data.frame, p)
    } else {
      p[[1]]
    }

  }

)
