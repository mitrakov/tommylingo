val http4sVersion = "0.23.18"
val http4sXmlVersion = "0.23.13"
val logbackVersion = "1.4.6"
val doobieVersion = "1.0.0-RC2"
val circeVersion = "0.14.5"

organization := "com.mitrakoff.self"
name := "tommyserver"
version := "23.12.17" // !!! change version here, then run "sbt docker:publish"
scalaVersion := "3.2.1"
libraryDependencies ++= Seq(
  "org.http4s"    %% "http4s-ember-server"   % http4sVersion,
  "org.http4s"    %% "http4s-dsl"            % http4sVersion,
  "org.http4s"    %% "http4s-circe"          % http4sVersion,
  "org.http4s"    %% "http4s-scala-xml"      % http4sXmlVersion,
  "ch.qos.logback" % "logback-classic"       % logbackVersion,
  "org.tpolecat"  %% "doobie-postgres"       % doobieVersion, // includes org.postgresql.Driver
  "org.tpolecat"  %% "doobie-postgres-circe" % doobieVersion, // json support
  "org.tpolecat"  %% "doobie-hikari"         % doobieVersion,
  "io.circe"      %% "circe-generic"         % circeVersion,
)

enablePlugins(JavaAppPackaging)

Compile / mainClass := Some("com.mitrakoff.self.Main")
Docker / packageName := "mitrakov/tommy-server"
dockerBaseImage := "adoptopenjdk:11-jre-hotspot"
dockerExposedPorts ++= Seq(8080)
