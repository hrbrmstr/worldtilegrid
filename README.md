
[![Travis-CI Build
Status](https://travis-ci.org/hrbrmstr/worldtilegrid.svg?branch=master)](https://travis-ci.org/hrbrmstr/worldtilegrid)

# worldtilegrid \[WIP\]

A ggplot2 Geom for World Tile Grids

## Description

A “tile grid map” is a cartogram that uses same-sized tiles in
approximate, relative positions of each other to represent a world map.
The world tile grid relative position reference system used by this
‘ggplot2’ ‘Geom/Stat’ was the original work of ‘Jon Schwabish’ and
converted to ‘CSV’ by ‘Maarten Lambrechts’.

  - Ref: <https://policyviz.com/2017/10/12/the-world-tile-grid-map/>
  - Ref:
    <http://www.maartenlambrechts.com/2017/10/22/tutorial-a-worldtilegrid-with-ggplot2.html>

## What’s Inside The Tin

The following functions are implemented:

``` r
devtools::install_git("https://git.rud.is/hrbrmstr/worldtilegrid.git")
# or
devtools::install_git("https://git.sr.ht/~hrbrmstr/worldtilegrid")
# or
devtools::install_gitlab("hrbrmstr/worldtilegrid")
# or
devtools::install_github("hrbrmstr/worldtilegrid")
```

The following *data* is included/exported:

`wtg`: World Tile Grid Basemap Data

## Installation

  - `geom_wtg`: World Tile Grid Geom
  - `theme_enhance_wtg`: World tile grid theme cruft remover that can be
    used with any other theme
  - `wtg`: World Tile Grid Basemap Data

## Usage

``` r
library(worldtilegrid)
library(tidyverse)

# current verison
packageVersion("worldtilegrid")
```

    ## [1] '0.2.0'

### Example (All countries are in the data set)

``` r
iso3cs <- worldtilegrid::wtg$alpha.3

set.seed(1)
data_frame(
  ctry = iso3cs,
  `Thing Val` = sample(1000, length(ctry))
) -> xdf

ggplot(xdf, aes(country = ctry, fill = `Thing Val`)) +
  geom_wtg(border_size = 0.5, border_col = "#252a32") +
  geom_text(
    aes(
      label = stat(alpha.2), 
      colour = I(ifelse(`Thing Val` < 500, "white", "black"))
    ), 
    stat = "wtg", size = 2
  ) + 
  coord_equal() +
  viridis::scale_fill_viridis() +
  labs(title = "World Tile Grid") +
  hrbrthemes::theme_ft_rc() +
  theme_enhance_wtg()
```

<img src="README_files/figure-gfm/unnamed-chunk-3-1.png" width="768" />

### Example (Only a few countries are in the data set)

``` r
set.seed(1)
data_frame(
  ctry = worldtilegrid::wtg$alpha.3[1:30],
  `Thing Val` = sample(1000, length(ctry))
) -> xdf

ggplot(xdf, aes(country = ctry, fill = `Thing Val`)) +
  geom_wtg() +
  geom_text(
    aes(
      label = stat(alpha.2),
      colour = I(ifelse(`Thing Val` < 400, "#b2b2b2", "#2b2b2b"))
    ), 
    stat="wtg", size=2
  ) + 
  coord_equal() +
  viridis::scale_fill_viridis() +
  labs(title = "World Tile Grid") +
  hrbrthemes::theme_ft_rc() +
  theme_enhance_wtg()
```

<img src="README_files/figure-gfm/unnamed-chunk-4-1.png" width="768" />

### Facet Example (All countries are in the data set)

``` r
set.seed(1)
data_frame(
  ctry = worldtilegrid::wtg$alpha.3,
  `Thing Val` = sample(1000, length(ctry)),
  grp = 'Thing One'
) -> xdf1

data_frame(
  ctry = worldtilegrid::wtg$alpha.3,
  `Thing Val` = sample(1000, length(ctry)),
  grp = 'Thing Two'
) -> xdf2

bind_rows(
  xdf1,
  xdf2
) -> xdf

ggplot(xdf, aes(country = ctry, fill = `Thing Val`)) +
  geom_wtg() +
  coord_equal() +
  facet_wrap(~grp) +
  viridis::scale_fill_viridis() +
  labs(title = "World Tile Grid Facets") +
  hrbrthemes::theme_ft_rc() +
  theme_enhance_wtg()
```

<img src="README_files/figure-gfm/unnamed-chunk-5-1.png" width="960" />

### Facet Example (Only a few countries are in the data set)

The geom will fill in the gaps for you:

``` r
set.seed(1)
tibble(
  ctry = sample(iso3cs, 40),
  `Thing Val` = sample(1000, length(ctry)),
  grp = 'Thing One'
) -> xdf1

tibble(
  ctry = sample(iso3cs, 40),
  `Thing Val` = sample(1000, length(ctry)),
  grp = 'Thing Two'
) -> xdf2

bind_rows(
  xdf1,
  xdf2
) -> xdf

ggplot(xdf, aes(country = ctry, fill = `Thing Val`)) +
  geom_wtg(border_size = 0.5) +
  coord_equal() +
  facet_wrap(~grp) +
  scale_fill_viridis_c(
    na.value = alpha(hrbrthemes::ft_cols$gray, 2/5), direction = -1,
    option = "magma"
  ) +
  guides(
    fill = guide_colourbar(title.position = "top", title.hjust = 0.5)
  ) +
  labs(title = "World Tile Grid Facets") +
  hrbrthemes::theme_ipsum_rc() +
  theme_enhance_wtg() +
  theme(legend.position = "bottom") +
  theme(legend.key.width = unit(2, "lines"))
```

<img src="README_files/figure-gfm/unnamed-chunk-6-1.png" width="960" />
