## libraries ----
library(mlr3)
library(mlr3spatial)
library(mlr3learners)
library(sf)
library(dplyr)

## data import ----

ds801 <- readRDS("./data/external/ds801_geochem1km.rds") |>
  sf::st_as_sf(coords = c("longitude", "latitude"))
chicago <- readRDS("./data/external/chicago_grid1km.rds") |>
  sf::st_as_sf(coords = c("x", "y"))

## data preparation ----

# target variable log transformations
# target_vars <- c("pb_ppm", "zn_ppm", "c_org_pct")
# ds801 <-
#   ds801 |>
#     mutate(across(target_vars, log1p, .names= "log_{.col}"))
ds801$log_pb = log1p(ds801$pb_ppm)
# ds801$log_zn = log1p(ds801$zn_pmm)
# ds801$log_c = log1p(ds801$c_org_pct)

# feature variable selector (imported from tutorial)
pb_feats <- c(readRDS("./data/external/pb.pr.vars.rds"), "hzn_depth")
ds801_ids <- c("state", "site_id", "ID")

# regression matrix
ds801_pb = ds801[,c("log_pb", pb_feats)] |> ## select relevant cols for task
  tidyr::drop_na()                                     ## drop incomplete rows

## mlr3 pipeline for lead ----

# task
task_ds801 <- as_task_regr_st(ds801_pb, target = "log_pb")

# learner
lrn_rf <- lrn("regr.ranger")

# initialise group and stratum roles
task_ds801$col_roles$group = "site_id"
task_ds801$col_roles$stratum = c("state", "ID")

# resampling
rsmp_cv

