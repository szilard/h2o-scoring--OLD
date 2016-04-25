
import h2o
h2o.init()

md = h2o.load_model("1-train+model/test_airline_GBM_100k")

dx_test = h2o.import_file("https://s3.amazonaws.com/benchm-ml--main/test.csv")
dx_test1 = dx_test[0,0:8]
dx_test1.as_data_frame()


%time md.predict(dx_test1).as_data_frame()    ## h2o frame
## Wall time: 120 ms


dpy_test1 = dx_test1.as_data_frame()   ## py object (pandas)

%time md.predict(h2o.H2OFrame.from_python(dpy_test1, column_names = ["Month","DayofMonth","DayOfWeek","DepTime","UniqueCarrier","Origin","Dest","Distance"])).as_data_frame()
## Wall time: 255 ms


# %time dx_test1_2 = h2o.H2OFrame.from_python(dpy_test1, column_names = ["Month","DayofMonth","DayOfWeek","DepTime","UniqueCarrier","Origin","Dest","Distance"])
# ## Wall time: 134 ms
# dx_test1_2.as_data_frame()
# %time md.predict(dx_test1_2).as_data_frame()
# ## Wall time: 121 ms


