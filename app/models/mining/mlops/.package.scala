package models.mining

/**
 * Created by chetan on 08/04/15.
 */
package object mlops {

  val conf = new SparkConf().setAppName("Veracion-Algorithms").setMaster("local")
  lazy val sc = new SparkContext(conf)

}