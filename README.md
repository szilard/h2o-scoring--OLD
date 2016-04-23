
## Scoring machine learning models with h2o.ai

#### Various options/directions for deploying h2o.ai models (GBM) to production

**Warning:** This is not production-level code, just prototyping various scoring options/directions for now.

#### 1. Java code

[Export Java code](2-pojo) (POJO) and use that for scoring (from Java).

Problem: Cannot compile the code (for GBM) due to [bug](https://0xdata.atlassian.net/browse/PUBDEV-1395).


#### 2. From R

Scoring [from R](3-from_R) (the R package too uses actually the REST API)

Speed:

```
   nrows run_time    qps
1  1e+00    0.113      9
2  3e+00    0.114     26
3  1e+01    0.109     92
4  3e+01    0.108    278
5  1e+02    1.123     89
6  3e+02    1.130    265
7  1e+03    1.132    883
8  3e+03    1.129   2657
9  1e+04    1.135   8811
10 3e+04    2.165  13857
11 1e+05    5.246  19062  -- 1 core
12 3e+05    6.259  47931  -- 4 cores
13 1e+06    8.362 119589  -- 16 cores
14 3e+06   25.041 119804
15 1e+07   71.186 140477
```


#### 3. h2o REST API

...

