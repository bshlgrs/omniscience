package webapp

import scala.scalajs.js._
import scala.scalajs.js.annotation.JSExport
import usage_tracker.UsageData
import org.scalajs.jquery.jQuery

@JSExport
object WebInterface extends JSApp {
  @JSExport
  def main(): Unit = {
    jQuery("#main-button").on("click", (_:Any) => {
      val thing = new UsageData

      println(thing.getString)
      println(JsInterface.getString)
    })
  }
}
