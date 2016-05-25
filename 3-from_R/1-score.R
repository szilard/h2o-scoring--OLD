
library(h2o)
h2o.init(nthreads = -1)

##dx_test <- h2o.importFile("https://s3.amazonaws.com/benchm-ml--main/test.csv")
# use larger dataset for scoring; using train OK as we are just measuring scoring time, not accuracy:
dx_test <- h2o.importFile("https://s3.amazonaws.com/benchm-ml--main/train-10m.csv")


md <- h2o.loadModel("1-train+model/test_airline_GBM_100k")


d_score_time <- data.frame()
for (n in c(1,3,10,30,100,300,1000,3000,10000,30000,1e5,3e5,1e6,3e6,1e7)) {
  dx_test_now <- dx_test[1:n,1:(ncol(dx_test)-1)]   ## h2o frame
  dR_test_now <- as.data.frame(dx_test_now)         ## R dataframe
  
  cat("upload only",n,"\n")
  tm_upl <- system.time({ dx_upload_only <- as.h2o(dR_test_now)})[[3]]  
  print(tm_upl)

  cat("all (scoring + R->h2o upload)",n,"\n")
  tm_all <- system.time({ score <- h2o.predict(md, as.h2o(dR_test_now))})[[3]]  
  print(tm_all)
  
  cat("h2o scoring with data already there",n,"\n")
  tm_h2o <- system.time({ score <- h2o.predict(md, dx_test_now)})[[3]]   
  print(tm_h2o)
  
  d_score_time <- rbind(d_score_time, 
      data.frame(nrows = n, run_all = tm_all, qps_all = round(n/tm_all), 
                            run_h2o = tm_h2o, qps_h2o = round(n/tm_h2o), run_upl = tm_upl))
}
d_score_time

