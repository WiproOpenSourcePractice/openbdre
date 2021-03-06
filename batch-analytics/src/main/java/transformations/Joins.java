package transformations;

import com.wipro.ats.bdre.md.api.GetMessageColumns;
import com.wipro.ats.bdre.md.api.GetProperties;
import messageschema.SGDataTypes;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.function.Function;
import org.apache.spark.api.java.function.Function3;
import org.apache.spark.broadcast.Broadcast;
import org.apache.spark.sql.DataFrame;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SQLContext;
import org.apache.spark.sql.types.DataType;
import org.apache.spark.sql.types.DataTypes;
import org.apache.spark.sql.types.StructField;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.sql.types.StructType;
import scala.Tuple2;
import util.WrapperMessage;
import org.apache.spark.api.java.JavaSparkContext;
import java.util.*;
import java.util.Map;

/**
 * Created by cloudera on 7/4/17.
 */
public class Joins implements Transformation {



    public static final Map<String,DataType> dataTypesMap = new SGDataTypes().dataTypesMap;
    @Override
    public JavaPairRDD<String,WrapperMessage> transform(JavaRDD emptyRDD, Map<Integer, JavaPairRDD<String,WrapperMessage>> prevRDDMap, Map<Integer, Set<Integer>> prevMap, Integer pid, StructType schema,Map<String,Broadcast<HashMap<String,String>>> broadcastMap,JavaSparkContext sc) {
        //List<Integer> prevPidList = new ArrayList<>();
        //prevPidList.addAll(prevMap.get(pid));
        GetProperties getProperties = new GetProperties();
        Properties filterProperties = getProperties.getProperties(String.valueOf(pid), "join_prop");
        String[] joinProcessArray=filterProperties.getProperty("joinProcessOrder").split(",");
        System.out.println(joinProcessArray);
        final String joinMessage1 = filterProperties.getProperty(joinProcessArray[0]+".joinTable");
        final String joinColumn1 = filterProperties.getProperty(joinProcessArray[0]+".joinColumn").split(":")[0];
        System.out.println(joinProcessArray[0]+" "+joinMessage1+" "+joinColumn1.split(":")[0]);
        /*Integer prevPid1 = prevPidList.get(0);
        System.out.println("before entering for loop first prevPid1 = " + prevPid1);
        GetProperties getProperties = new GetProperties();
        Properties filterProperties = getProperties.getProperties(String.valueOf(prevPid1), "default");
        final String joinMessage1 = filterProperties.getProperty("join-message");
        final String joinColumn1 = filterProperties.getProperty("join-column");
        //joinType - One of: inner, outer, left_outer, right_outer, leftsemi.
        final String joinType = filterProperties.getProperty("join-type");*/

        JavaPairRDD<String,WrapperMessage> joinPairRDD = prevRDDMap.get(Integer.valueOf(joinProcessArray[0]));
        JavaRDD<WrapperMessage> joinRDD = joinPairRDD.map(s -> s._2);
        Set<String> columnsDataTypesSet = new GetMessageColumns().getMessageColumnNames(Integer.valueOf(joinProcessArray[0]));
        List<StructField> fields = new ArrayList<>();
        for(String columnDatatype: columnsDataTypesSet){
            String[] columnDatatypeArray = columnDatatype.split(":");
            StructField field = DataTypes.createStructField(columnDatatypeArray[0], dataTypesMap.get(columnDatatypeArray[1]), true);
            fields.add(field);
        }
        StructType schema1 = DataTypes.createStructType(fields);
        JavaRDD<WrapperMessage> finalRDD = emptyRDD;
        for(int i=1;i< joinProcessArray.length;i++){
            /*Integer currentPid = prevPidList.get(i);
            System.out.println("join of dstream of pid = " + currentPid);
            filterProperties = getProperties.getProperties(String.valueOf(currentPid), "default");
            final String joinMessage2 = filterProperties.getProperty("join-message");
            final String joinColumn2 = filterProperties.getProperty("join-column");*/
            final String joinMessage2 = filterProperties.getProperty(joinProcessArray[i]+".joinTable");
            final String joinColumn2 = filterProperties.getProperty(joinProcessArray[i]+".joinColumn").split(":")[0];
            final String joinType = filterProperties.getProperty(joinProcessArray[i]+".joinType");
            System.out.println(joinProcessArray[i]+" "+joinMessage2+" "+joinColumn2.split(":")[0]+" "+joinType);
            JavaPairRDD<String,WrapperMessage> pairRDD1 = prevRDDMap.get(Integer.valueOf(joinProcessArray[i]));
            JavaRDD<WrapperMessage> rdd1 = pairRDD1.map(s -> s._2);

            Set<String> columnsDataTypesSet2 = new GetMessageColumns().getMessageColumnNames(Integer.valueOf(Integer.valueOf(joinProcessArray[i])));
            List<StructField> fields2 = new ArrayList<>();
            for(String columnDatatype: columnsDataTypesSet2){
                String[] columnDatatypeArray = columnDatatype.split(":");
                StructField field = DataTypes.createStructField(columnDatatypeArray[0], dataTypesMap.get(columnDatatypeArray[1]), true);
                fields2.add(field);
            }
            StructType schema2 = DataTypes.createStructType(fields2);


            if(joinRDD!=null && rdd1!=null){


                        JavaRDD<Row> rddRow1 = joinRDD.map(new Function<WrapperMessage, Row>() {
                                                                          @Override
                                                                          public Row call(WrapperMessage wrapperMessage) throws Exception {
                                                                              return wrapperMessage.getRow();
                                                                          }
                                                                      });



                        JavaRDD<Row> rddRow2 = rdd1.map(new Function<WrapperMessage, Row>() {
                                                                          @Override
                                                                          public Row call(WrapperMessage wrapperMessage) throws Exception {
                                                                              return wrapperMessage.getRow();
                                                                          }
                                                                      });



                        SQLContext sqlContext1 = SQLContext.getOrCreate(joinRDD.context());
                        DataFrame dataFrame1=null;
                        try{
                            if(rddRow1.count()>0)
                                dataFrame1 = sqlContext1.createDataFrame(rddRow1, rddRow1.take(1).get(0).schema());
                        }
                        catch(Exception e){
                            System.out.println("Exception while inferring schema from RDD = " + e);
                            dataFrame1 = sqlContext1.createDataFrame(rddRow1, schema1);
                        }
                        //DataFrame dataFrame1 = sqlContext1.createDataFrame(rddRow1, schema1);

                        SQLContext sqlContext2 = SQLContext.getOrCreate(rdd1.context());
                        DataFrame dataFrame2 = sqlContext2.createDataFrame(rddRow2, schema2);

                        DataFrame returnDF = null;

                        if(dataFrame1!=null && !dataFrame1.rdd().isEmpty() && dataFrame2!=null && !dataFrame2.rdd().isEmpty()){
                            System.out.println("showing dataframe before intersect ");
                            dataFrame1.show(100);
                            dataFrame2.show(100);
                            returnDF = dataFrame1.join(dataFrame2, dataFrame1.col(joinColumn1).equalTo(dataFrame2.col(joinColumn2)), joinType);
                           returnDF = returnDF.drop(joinColumn2);
                            String col1="";
                            String col2="";
                            System.out.println("showing dataframe after intersect ");
                            returnDF.show(100);
                        }


                        if (returnDF != null) {
                            finalRDD = returnDF.javaRDD().map(new Function<Row, WrapperMessage>() {
                                                                  @Override
                                                                  public WrapperMessage call(Row row) throws Exception {
                                                                      return new WrapperMessage(row);
                                                                  }
                                                              }
                            );

                        }

                        // return filteredDF.javaRDD();
                    }


            }




        return finalRDD.mapToPair(s -> new Tuple2<String, WrapperMessage>(null,s));
    }
}
