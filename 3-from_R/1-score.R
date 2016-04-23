
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

# nrows run_time    qps
# 1  1e+00    0.113      9
# 2  3e+00    0.114     26
# 3  1e+01    0.109     92
# 4  3e+01    0.108    278
# 5  1e+02    1.123     89
# 6  3e+02    1.130    265
# 7  1e+03    1.132    883
# 8  3e+03    1.129   2657
# 9  1e+04    1.135   8811
# 10 3e+04    2.165  13857
# 11 1e+05    5.246  19062  -- 1 core
# 12 3e+05    6.259  47931  -- 4 cores
# 13 1e+06    8.362 119589  -- 16 cores
# 14 3e+06   25.041 119804
# 15 1e+07   71.186 140477


