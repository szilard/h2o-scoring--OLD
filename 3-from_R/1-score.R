
library(h2o)
h2o.init(nthreads = -1)

##dx_test <- h2o.importFile("https://s3.amazonaws.com/benchm-ml--main/test.csv")
dx_test <- h2o.importFile("https://s3.amazonaws.com/benchm-ml--main/train-10m.csv")

md <- h2o.loadModel("1-train+model/test_airline_GBM_100k")


d_score_time <- data.frame()
##for (n in c(1,3,10,30,100,300,1000,3000,10000,30000,1e5)) {
for (n in c(1,3,10,30,100,300,1000,3000,10000,30000,1e5,3e5,1e6,3e6,1e7)) {
  dx_test_now <- dx_test[1:n,1:(ncol(dx_test)-1)]
  print(n)
  tm <- system.time({ score <- h2o.predict(md, dx_test_now)})[[3]]
  d_score_time <- rbind(d_score_time, data.frame(nrows = n, run_time = tm, qps = round(n/tm)))
}
d_score_time

