package webapp

import scala.scalajs.js._
import scala.scalajs.js.annotation.JSExport
import usage_tracker.UsageData
import org.scalajs.jquery

@JSExport
object WebInterface extends JSApp {
  @JSExport
  def main(): Unit = {
    jQuery("#main-button").on("click", (_:Any) => {
      val data = jQuery("#location-data-input").text()

      println(data)
    })
  }
}
