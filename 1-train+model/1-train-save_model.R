
library(h2o)
h2o.init(nthreads = -1)

dx_train <- h2o.importFile("https://s3.amazonaws.com/benchm-ml--main/train-0.1m.csv")
dx_valid <- h2o.importFile("https://s3.amazonaws.com/benchm-ml--main/valid.csv")
dx_test <- h2o.importFile("https://s3.amazonaws.com/benchm-ml--main/test.csv")


system.time({
  md <- h2o.gbm(x = 1:(ncol(dx_train)-1), y = ncol(dx_train), training_frame = dx_train, 
                model_id = "test_airline_GBM_100k",
                ntrees = 100, max_depth = 10, learn_rate = 0.1, nbins = 100,
                validation_frame = dx_valid,
                stopping_rounds = 5, stopping_metric = "AUC", stopping_tolerance = 1e-3)
})


system.time({
  print(h2o.auc(h2o.performance(md, dx_test)))
})


h2o.saveModel(md, "1-train+model")

