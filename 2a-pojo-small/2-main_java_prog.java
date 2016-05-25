import java.io.*;
import hex.genmodel.easy.RowData;
import hex.genmodel.easy.EasyPredictModelWrapper;
import hex.genmodel.easy.prediction.*;

public class main {
   private static String modelClassName = "test_airline_GBM_100k_SMALL";

   public static void main(String[] args) throws Exception {
     hex.genmodel.GenModel rawModel;
     rawModel = (hex.genmodel.GenModel) Class.forName(modelClassName).newInstance();
     EasyPredictModelWrapper model = new EasyPredictModelWrapper(rawModel);

//  Month DayofMonth DayOfWeek DepTime UniqueCarrier Origin Dest Distance dep_delayed_15min
//   c-7       c-25       c-3     615            YV    MRY  PHX      598                 N

     RowData row = new RowData();
     row.put("Month", "c-1");
     row.put("DayofMonth", "c-2");
     row.put("DayOfWeek", "c-2");
     row.put("DepTime", "715");
     row.put("UniqueCarrier", "YV");
     row.put("Origin", "MRY");
     row.put("Dest", "PHX");
     row.put("Distance", "298");
     BinomialModelPrediction p = model.predictBinomial(row);

     RowData row2 = new RowData();
     row2.put("Month", "c-7");
     row2.put("DayofMonth", "c-25");
     row2.put("DayOfWeek", "c-3");
     row2.put("DepTime", "615");
     row2.put("UniqueCarrier", "YV");
     row2.put("Origin", "MRY");
     row2.put("Dest", "PHX");
     row2.put("Distance", "598");

     long startTime = System.nanoTime();
     BinomialModelPrediction p2 = model.predictBinomial(row2);
     long stopTime = System.nanoTime();
     System.out.println((stopTime - startTime)/1000000.0);

     System.out.print(p2.classProbabilities[1]);

   } 
}

