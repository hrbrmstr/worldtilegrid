#' World tile grid theme cruft remover that can be used with any other theme
#'
#' Removes:
#'
#' - panel grid
#' - all axis text
#' - all axis ticks
#' - all axis titles
#'
#' @md
#' @param move_legend if `TRUE` will move the legend to c(0.2, 0.2) and make it
#'        horizontal as well as give it a width of 2 lines. You should add a call
#'        to `guides(fill = guide_colourbar(title.position="top"))` and, perhaps,
#'        center the legend title. Default is `FALSE` for backwards compatibility.
#' @export
theme_enhance_wtg <- function(move_legend = FALSE) {

  ret <- theme(panel.grid = element_blank())
  ret <- ret + theme(axis.text = element_blank())
  ret <- ret + theme(axis.text.x = element_blank())
  ret <- ret + theme(axis.text.y = element_blank())
  ret <- ret + theme(axis.title = element_blank())
  ret <- ret + theme(axis.title.x = element_blank())
  ret <- ret + theme(axis.title.x.top = element_blank())
  ret <- ret + theme(axis.title.x.bottom = element_blank())
  ret <- ret + theme(axis.title.y = element_blank())
  ret <- ret + theme(axis.title.y.left = element_blank())
  ret <- ret + theme(axis.title.y.right = element_blank())

  if (move_legend) {
    ret <- ret + theme(legend.direction = "horizontal")
    ret <- ret + theme(legend.position = c(0.2, 0.2))
    ret <- ret + theme(legend.key.width = unit(2, "lines"))
  }

  ret

}