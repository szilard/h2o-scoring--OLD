
## Scoring machine learning models with h2o.ai

#### Various options for deploying h2o.ai models (GBM) to production

**Warning:** This is not production-level code, just prototyping various scoring options for now.

#### 1. Java code

[Export Java code](2-pojo) (POJO) and use that for scoring (from Java).

Problem: Cannot compile the code (for GBM) due to [bug](https://0xdata.atlassian.net/browse/PUBDEV-1395).


#### 2. From R

Scoring [from R](3-from_R) (the R package too uses actually the REST API)

Timings (not rigourous):
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


#### 3. h2o REST API

...

