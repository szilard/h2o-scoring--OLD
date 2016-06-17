
library(h2o)
h2o.init(nthreads = -1)

md <- h2o.loadModel("1-train+model/test_airline_GBM_100k")

dx_test <- h2o.importFile("https://s3.amazonaws.com/benchm-ml--main/test.csv")
dR_test <- as.data.frame(dx_test[1,1:(ncol(dx_test)-1)] )
  

h2o.startLogging("3-from_R/log-all_incl_upload.log")

system.time({ 
  score <- h2o.predict(md, as.h2o(dR_test))
})

h2o.stopLogging()

# user  system elapsed 
# 0.198   0.006   0.292 