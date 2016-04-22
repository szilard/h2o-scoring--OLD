
library(h2o)
h2o.init(nthreads = -1)

dx_test <- h2o.importFile("https://s3.amazonaws.com/benchm-ml--main/test.csv")


md <- h2o.loadModel("1-train+model/test_airline_GBM_100k")


system.time({
  print(h2o.auc(h2o.performance(md, dx_test)))
})

