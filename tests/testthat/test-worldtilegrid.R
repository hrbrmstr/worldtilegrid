context("wtg data joins correctly & ggplot2 data structures are created properly")
test_that("wtg data joins properly", {

  require(ggplot2)
  require(worldtilegrid)

  set.seed(1)

  data.frame(
    ctry = worldtilegrid::wtg$alpha.3[1:2],
    val = sample(1000, length(worldtilegrid::wtg$alpha.3[1:2])),
    stringsAsFactors = FALSE
  ) -> xdf

  ggplot(xdf, aes(country = ctry, fill = val)) +
    geom_wtg() +
    geom_text(aes(label = stat(alpha.2)), stat="wtg", size=2) + # re-compute the stat to label
    coord_equal() +
    viridis::scale_fill_viridis(direction = -1) +
    labs(title = "World Tile Grid") +
    theme_minimal() +
    theme_enhance_wtg() -> gg

  suppressMessages(gb <- ggplot_build(gg))

  expect_equal(length(gb$data), 2)
  expect_identical(dim(gb$data[[1]]), c(192L, 24L))
  expect_identical(dim(gb$data[[2]]), c(192L, 24L))
  expect_identical(gb$data[[1]]$group, gb$data[[2]]$group)

})
