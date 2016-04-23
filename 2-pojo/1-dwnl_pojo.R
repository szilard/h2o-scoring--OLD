
library(h2o)
h2o.init(nthreads = -1)


md <- h2o.loadModel("1-train+model/test_airline_GBM_100k")


h2o.download_pojo(md, path = "2-pojo", getjar = TRUE)


