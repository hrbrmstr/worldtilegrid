#' A ggplot2 Geom for World Tile Grids
#'
#' A "tile grid map" is a cartogram that uses same-sized tiles
#' in approximate, relative positions of each other to represent a world
#' map. The world tile grid relative position reference system used by
#' this 'ggplot2' 'Geom/Stat' was the original work of 'Jon Schwabish' and
#' converted to 'CSV' by 'Maarten Lambrechts'.
#'
#' - Ref: <https://policyviz.com/2017/10/12/the-world-tile-grid-map/>
#' - Ref: <http://www.maartenlambrechts.com/2017/10/22/tutorial-a-worldtilegrid-with-ggplot2.html>
#'
#' @md
#' @name worldtilegrid
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @author Maarten Lambrechts
#' @author Jon Schwabish
#' @importFrom grid unit
#' @importFrom scales alpha
#' @importFrom plyr rbind.fill
#' @importFrom ggplot2 ggplot geom_tile scale_fill_manual guides geom_tile ggplotGrob
#' @importFrom ggplot2 geom_point geom_text scale_color_manual guides theme labs
#' @importFrom ggplot2 scale_x_continuous scale_y_continuous coord_equal theme_bw
#' @importFrom ggplot2 aes element_rect element_blank element_text resolution
#' @importFrom ggplot2 aes_string aes_ scale_y_reverse layer GeomRect margin %+replace%
#' @importFrom ggplot2 scale_fill_brewer ggtitle rel ggproto draw_key_polygon Geom Stat
"_PACKAGE"

#' @title World Tile Grid Basemap Data
#' @docType data
#' @name wtg
#' @export
NULL