## libraries ----
library(mlr3)
library(mlr3spatial)
library(mlr3learners)
library(sf)

## data import ----

ds801 <- readRDS("./data/external/ds801_geochem1km.rds") |>
  sf::st_as_sf(coords = c("latitude", "longitude"))
chicago <- readRDS("./data/external/chicago_grid1km.rds")

## data preparation ----

# variable transformations
ds801$log_pb = log1p(ds801$pb_ppm)  ## log transformation

# feature variable selector (imported from tutorial)
pb_feats <- c(readRDS("./data/external/pb.pr.vars.rds"), "hzn_depth")
ds801_ids <- c("state", "site_id", "ID")

# regression matrix
ds801_pb = ds801[,c("ID", "log_pb", pb_feats)] |> ## select relevant cols for task
  tidyr::drop_na()                                     ## drop incomplete rows

## mlr3 pipeline ----

# task
task_ds801 <- as_task_regr_st(ds801_pb, target = "log_pb")

# initialise site `ID`
task_ds801$col_roles$group = "site_id"
