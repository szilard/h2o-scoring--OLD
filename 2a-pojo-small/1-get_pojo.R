
library(h2o)
h2o.init(nthreads = -1)

dx_train <- h2o.importFile("https://s3.amazonaws.com/benchm-ml--main/train-0.1m.csv")


system.time({
  md <- h2o.gbm(x = 1:(ncol(dx_train)-1), y = ncol(dx_train), training_frame = dx_train, 
                model_id = "test_airline_GBM_100k_SMALL",
## ORIG/FAIL:   ntrees = 100, max_depth = 10, learn_rate = 0.1, nbins = 100
## FAIL:        ntrees = 100, max_depth = 10, learn_rate = 0.1, nbins = 10
## OK:          ntrees = 100, max_depth = 3, learn_rate = 0.1, nbins = 100
## FAIL:        ntrees = 10, max_depth = 10, learn_rate = 0.1, nbins = 100
#  OK:          ntrees = 10, max_depth = 3, learn_rate = 0.1, nbins = 10

## OK:          ntrees = 100, max_depth = 9, learn_rate = 0.1, nbins = 100
## FAILS:       ntrees = 100, max_depth = 10, learn_rate = 0.1, nbins = 100
                ntrees = 100, max_depth = 9, learn_rate = 0.1, nbins = 100
               )
})


h2o.download_pojo(md, path = "2a-pojo-small", getjar = TRUE)


