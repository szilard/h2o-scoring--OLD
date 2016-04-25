
## Scoring machine learning models with h2o.ai

#### Various options for deploying h2o.ai models (GBM) to production

**Warning:** This is not production-level code, just prototyping various directions for now.

#### 1. Java code

[Export Java code](2-pojo) (POJO) and use that for scoring (from Java).

Problem: Cannot compile the code (for GBM) due to [bug](https://0xdata.atlassian.net/browse/PUBDEV-1395).


#### 2. From R

Scoring [from R](3-from_R) (the R package too uses actually the REST API)

[Timings](3-from_R/1-score.R) (not rigourous):
```
  nrows run_all qps_all run_h2o qps_h2o run_upl
1  1e+00   0.322       3   0.084      12   0.253
2  3e+00   0.321       9   0.085      35   0.282
3  1e+01   0.361      28   0.080     125   0.243
4  3e+01   0.326      92   0.082     366   0.240
5  1e+02   0.365     274   0.082    1220   0.291
6  3e+02   1.348     223   1.102     272   0.291
7  1e+03   1.412     708   1.101     908   0.262
8  3e+03   1.444    2078   1.097    2735   0.326
9  1e+04   1.476    6775   1.099    9099   0.369
10 3e+04   2.696   11128   2.119   14158   0.527
11 1e+05   7.326   13650   5.180   19305   1.171
12 3e+05  10.189   29444   6.199   48395   1.959
13 1e+06  19.926   50186   8.279  120788   5.055
14 3e+06  36.690   81766  24.809  120924  14.904
15 1e+07 120.168   83217  72.524  137885  53.917
```

(`run_all` is end-to-end run time with data in R that h2o automatically imports into its system and scores,
`run_upl` is the upload/import time, while `run_h2o` is the scoring part (but driven from R) - strangely the times do
not add up)

Uploads run mostly single core (except the h2o parsing at the very end). The scoring runs
single core on smaller sizes, uses 4 cores for `n=300,000` and all cores (16) for `n>=1M`.

Logging the REST calls for `n=1` the timing breakdown (millisec):
```
11      POST      /3/PostFile?destination_frame=%2Ftmp%2FRtmpTkbyXR%2Ffile478955b01496.csv_sid_8c96_16
10      GET       /3/Cloud?skip_ticks=true
11      POST      /3/ParseSetup
9       GET       /3/Cloud?skip_ticks=true
19      POST      /3/Parse
10      GET       /3/Jobs/$03017f00000132d4ffffffff$_a6fd865986e9f70b3cce10d5a31b471f
7       GET       /3/Cloud?skip_ticks=true
10      GET       /3/Frames/dR_test?row_count=10
7       GET       /3/Cloud?skip_ticks=true
10      POST      /4/Predictions/models/test_airline_GBM_100k/frames/dR_test
9       GET       /3/Jobs/$03017f00000132d4ffffffff$_bed784af62482730622ad442027d47a0
9       GET       /3/Cloud?skip_ticks=true
15      GET       /3/Frames/predictions_98db_test_airline_GBM_100k_on_dR_test?row_count=10
```
([Code](3-from_R/2-score-RESTcalls.R), [logs](3-from_R/log-all_incl_upload.log), 
[analysis](3-from_R/2a-score-RESTcalls_analysis.txt))

Total time `~290 ms`. The above REST calls add up to `~140 ms` (the difference I assume is overhead of the
R packages such as logic, JSON parsing of responses etc.)

The first 9 calls are about getting the input data into h2o. The next 3 is an upper bound of how 
long the actual scoring takes (`<30 ms`: `/4/Predictions...`, `/3/Jobs/...`, `/3/Cloud...`) and the
last call is grabing the data from h2o back into R.


#### 3. h2o REST API

Same as above but driven from some other environment, constructing the REST calls from there.
For real-time scoring (1 item at a time) a lot of the above overhead can be cut. Order of magnitude-wise
probably total time can go down from `~300ms` to `~100 ms` maybe even `~50ms` (if there is a better way
to get data into h2o than via CSV). 

It would be interesting to compare that with the POJO (in case the above bug is fixed/worked around).
My guess is that for 1 item at a time scoring the POJO will be magnitudes faster (hoipefully), while for large bulk 
scoring maybe of same magnitude.

