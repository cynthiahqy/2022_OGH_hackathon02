sample_clustered_fold <- function(full_sample, cluster_var, cluster_cov_pct, cluster_train_pct){
  
  # ---- check cluster_var is factor ----
  cf <- full_sample[,cluster_var]
  stopifnot(is.factor(cf[[cluster_var]]))
  ## add row_id
  cf$row_id <- seq_along(cf[,1])
  
  # ---- randomly select units in cluster ----
  # calculation variables
  n_total_obs <- nrow(cf)
  n_total_units <- nlevels(cf[[cluster_var]]) 
  n_units_cluster <- ceiling(cluster_cov_pct * n_total_units)
  # random sample
  units_in_cluster <- sample(cf[[cluster_var]], n_units_cluster)

  # ---- sample training rows from extrapolation clusters (up to available units) ---
  # calculation vars
  cluster_bool <- cf[[cluster_var]] %in% units_in_cluster
  obs_extrap <- cf[["row_id"]][cluster_bool] ## ISSUE: how to deal with site_id grouping???
  n_extrap_obs <- length(obs_extrap)
  n_train_from_cluster <- ceiling(cluster_train_pct * n_train_obs)
  # test/train sample from cluster
  index <- list()
  if(n_available_obs <= n_train_from_cluster){
    index$train$cluster <- obs_extrap
    n_train_from_cluster <- n_available_obs
  } else {
    index$train$cluster <- sample(obs_extrap, n_train_from_cluster)
  }
  index$test$cluster <- setdiff(obs_in_cluster, index$train$cluster)
  
  # ---- sample training rows from in-sample clusters ----
  pct_train <- n_train_from_cluster / n_available_obs
  obs_other <- cf[["row_id"]][!cluster_bool]
  n_train_from_other = pct_train * (n_total_obs - n_train_from_cluster)
  index$train$other <- sample(obs_other, n_train_from_other)
  index$test$other <- setdiff(obs_other, index$test$other)
  
  return(index)
}

# fnc input
cluster_var = "ID"
cluster_train_pct = 0.2
cluster_cov_pct = 0.8

# internal prep
cf <- ds801 |> dplyr::transmute(ID = base::as.factor(ID))
cf
cf$row_id <- base::seq_along(cf[[1]])

### n_total_units set to 100 in de Bruin to simplify randomisation


# random select units in cluster
n_total_obs <- base::nrow(cf)
n_total_units <- base::nlevels(cf[["ID"]])
n_units_cluster <- base::ceiling(0.9 * n_total_units)
units_in_cluster <- base::sample(cf[["ID"]], n_units_cluster) ## outputs a factor!

# sample obs from cluster
cluster_bool <- cf[["ID"]] %in% units_in_cluster
obs_in_cluster <- cf[cf$cluster_bool, "row_id"]
n_available_obs <- length(obs_in_cluster)
n_train_from_cluster <- ceiling(0.5 * n_total_obs)

index <- list()
if(n_available_obs <= n_train_from_cluster){
  ## opt. 1: sample up to available units
  index$index_train <- obs_in_cluster
  ## opt. 2 shrink full sample???
} else {
  index$index_train <- sample(obs_in_cluster, n_train_from_cluster)
}
