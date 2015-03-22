name := "dataViewerWebPage"

version := "1.0"

scalaVersion := "2.11.5"

enablePlugins(ScalaJSPlugin)

libraryDependencies += "be.doeraene" %%% "scalajs-jquery" % "0.8.0"

libraryDependencies += "org.scala-lang.modules" %% "scala-xml" % "1.0.3"

scalaVersion := "2.11.5"

scalaJSStage in Global := FastOptStage

skip in packageJSDependencies := false
