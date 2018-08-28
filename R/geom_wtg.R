#' World Tile Grid Geom
#'
#' Pass in a data frame of countries (iso2c, i23c, name) and a value column and
#' get back a world tile grid. You don't need to have all countries in your
#' original data set, but this is a world tile grid and only having a few
#' countries may not make sense for the message you're trying to convey.
#'
#' Labeling world tile grids is a tricksy business and no labeling
#' parameters are planned for this since you should think very carefully about
#' the tradeoffs of tiny text/numbers vs readability. These charts are really
#' only good for overviews in single-chart form or highlighting stark differences
#' in panel-form. See the section on `Computed variables` for data that is
#' available to be used as labels.
#' \cr
#' There are two special/critical `aes()` mappings:
#' - `country` (so the geom knows which column to map the country names/abbrevs to)
#' - `fill` (which column you're mapping the filling for the squares with)
#'
#' @section Output sample:
#' \if{html}{
#' A sample of the output from \code{geom_wtg()}:
#'
#' \figure{geomwtg01.png}{alt="Figure: geomwtg01.png"}
#' }
#'
#' \if{latex}{
#' A sample of the output from \code{geom_wtg()}:
#'
#' \figure{geomwtg01.png}{options: width=20cm}
#' }
#'
#' @section Computed variables:
#' - `x`,`y`: the X,Y position of the tile
#' - `name`: Country name (e.g. `Afghanistan`)
#' - `country.code`: ISO2C country code abbreviation (e.g. `AF`)
#' - `iso_3166.2`: Full ISO 3166 2-letter abbreviation code (e.g. `ISO 3166-2:AF`)
#' - `region`: Region name (e.g. `Asia`)
#' - `sub.region`: Sub-region name (e.g. `Southern Asia`)
#' - `region.code`: Region code (e.g. `142`)
#' - `sub.region.code`: Sub-region code (e.g. `034`)
#'
#' @md
#' @param mapping Set of aesthetic mappings created by `aes()` or
#'   `aes_()`. If specified and `inherit.aes = TRUE` (the
#'   default), it is combined with the default mapping at the top level of the
#'   plot. You must supply `mapping` if there is no plot mapping.
#' @param data The data to be displayed in this layer. There are three
#'    options:
#'
#'    If `NULL`, the default, the data is inherited from the plot
#'    data as specified in the call to `ggplot()`.
#'
#'    A `data.frame`, or other object, will override the plot
#'    data. All objects will be fortified to produce a data frame. See
#'    `fortify()` for which variables will be created.
#'
#'    A `function` will be called with a single argument,
#'    the plot data. The return value must be a `data.frame.`, and
#'    will be used as the layer data.
#' @param border_col border color of the state squares, default "`white`"
#' @param border_size thickness of the square state borders
#' @param na.rm If `FALSE`, the default, missing values are removed with
#'   a warning. If `TRUE`, missing values are silently removed.
#' @param show.legend logical. Should this layer be included in the legends?
#'   `NA`, the default, includes if any aesthetics are mapped.
#'   `FALSE` never includes, and `TRUE` always includes.
#'   It can also be a named logical vector to finely select the aesthetics to
#'   display.
#' @param inherit.aes If `FALSE`, overrides the default aesthetics,
#'   rather than combining with them. This is most useful for helper functions
#'   that define both data and aesthetics and shouldn't inherit behaviour from
#'   the default plot specification, e.g. `borders()`.
#' @param ... other arguments passed on to `layer()`. These are
#'   often aesthetics, used to set an aesthetic to a fixed value, like
#'   `color = "red"` or `size = 3`. They may also be parameters
#'   to the paired geom/stat.
#' @export
#' @examples
#' set.seed(1)
#' data.frame(
#'   ctry = worldtilegrid::wtg$alpha.3,
#'   al = sample(1000, length(worldtilegrid::wtg$alpha.3))
#' ) -> xdf1
#'
#' ggplot(xdf, aes(country = ctry, fill = val)) +
#'   geom_wtg() +
#'   geom_text(aes(label = stat(alpha.2)), stat="wtg", size=2) + # re-compute the stat for labeling
#'   coord_equal() +
#'   viridis::scale_fill_viridis() +
#'   labs(title = "World Tile Grid") +
#'   theme_minimal() +
#'   theme_enhance_wtg()
geom_wtg <- function(
  mapping = NULL, data = NULL,
  border_col = "white", border_size = 0.125,
  na.rm = TRUE, show.legend = NA, inherit.aes = TRUE, ...) {

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = "wtg",
    geom = GeomWtg,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = TRUE,
      border_col = border_col,
      border_size = border_size,
      ...
    )
  )

}

#' @rdname geom_wtg
#' @export
GeomWtg <- ggplot2::ggproto(
  `_class` = "GeomWtg",
  `_inherit` = ggplot2::Geom,

  default_aes = ggplot2::aes(
    country = "country",
    fill = NA, colour = NA, alpha = NA,
    size = 0.1, linetype = 1, width = NA, height = NA
  ),

  required_aes = c("country", "fill"),

  extra_params = c("na.rm", "width", "height"),

  setup_data = function(data, params) {

    wtg.dat <- data.frame(data, stringsAsFactors=FALSE)

    if (max(nchar(wtg.dat[["country"]])) == 3) {
      merge.x <- "alpha.3"
    } else if (max(nchar(wtg.dat[["country"]])) == 2) {
      merge.x <- "alpha.2"
    } else {
      merge.x <- "name"
    }

    message("Using ", merge.x)

    wtg.dat$width <- wtg.dat$width %||% params$width %||% ggplot2::resolution(wtg.dat$x, FALSE)
    wtg.dat$height <- wtg.dat$height %||% params$height %||% ggplot2::resolution(wtg.dat$y, FALSE)

    transform(
      wtg.dat,
      xmin = x - width / 2,  xmax = x + width / 2,  width = NULL,
      ymin = y - height / 2, ymax = y + height / 2, height = NULL
    ) -> xdat

    xdat

  },

  draw_panel = function(self, data, panel_params, coord,
                        border_col = "white", border_size = 0.125) {

    tile_data <- data
    tile_data$size <- border_size
    tile_data$colour <- border_col

    coord <- ggplot2::coord_equal()

    grid::gList(
      GeomTile$draw_panel(tile_data, panel_params, coord)
    ) -> grobs

    ggname("geom_wtg", grid::grobTree(children = grobs))

  },

  draw_key = ggplot2::draw_key_polygon

)
