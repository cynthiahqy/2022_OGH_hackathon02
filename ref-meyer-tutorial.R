library(mlr3)
library(mlr3learners)
library(mlr3spatial)
library(mlr3spatiotempcv)
library(mlr3extralearners)
library(mlr3measures)

# initiate the model. 
# note: here we will define folds manually (via CAST's NNDM). Therefore we can define a "normal" task,
# because the spatial component is handeld in CAST. If this is not the case, create a TaskRegrST via mlr3spatiotempcv::as_task_regr_st

backend <- as_data_backend(trainDat[,c(model_ffs$selectedvars, "response")])
task <- as_task_regr(backend, target = "response") 
learner <- lrn("regr.randomForest", importance = "mse")
learner$train(task)

# Prepare Cross-validation
custom <- rsmp("custom")
train_sets <- NNDM_cv$indx_train # derived from CAST::nndm
test_sets <- NNDM_cv$indx_test # derived from CAST::nndm
rsmp_spcv_custom <- custom$instantiate(task, train_sets, test_sets) #create folds

# Model training and cross-validation
set.seed(seed)
rr <- mlr3::resample(task, learner, rsmp_spcv_custom) 

## predict:
prediction <- predict(predictors,learner$model)