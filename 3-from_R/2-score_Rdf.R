
library(h2o)
h2o.init(nthreads = -1)

dx_test <- h2o.importFile("https://s3.amazonaws.com/benchm-ml--main/test.csv")

md <- h2o.loadModel("1-train+model/test_airline_GBM_100k")


d_score_time <- data.frame()
for (n in c(1,3,10,30,100,300,1000,3000,10000,30000,1e5)) {
  d_test_now <- as.data.frame(dx_test[1:n,1:(ncol(dx_test)-1)])
  print(n)
  tm <- system.time({ score <- h2o.predict(md, as.h2o(d_test_now))})[[3]]
  d_score_time <- rbind(d_score_time, data.frame(nrows = n, run_time = tm, qps = round(n/tm)))
}
d_score_time

