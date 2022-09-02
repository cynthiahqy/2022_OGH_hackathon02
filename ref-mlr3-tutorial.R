library("mlr3")
library("mlr3spatiotempcv")
set.seed(42)

# be less verbose
lgr::get_logger("bbotk")$set_threshold("warn")
lgr::get_logger("mlr3")$set_threshold("warn")

task = tsk("ecuador")

learner = lrn("classif.rpart", maxdepth = 3, predict_type = "prob")
resampling_nsp = rsmp("repeated_cv", folds = 4, repeats = 2)
rr_nsp = resample(
  task = task, learner = learner,
  resampling = resampling_nsp)

rr_nsp$aggregate(measures = msr("classif.ce"))
