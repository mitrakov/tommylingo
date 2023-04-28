val http4sVersion = "0.23.13"
val logbackVersion = "1.4.6"
val doobieVersion = "1.0.0-RC2"

organization := "com.mitrakoff.self"
name := "tommylingo"
version := "1.0"
scalaVersion := "3.2.1"
libraryDependencies ++= Seq(
  "org.http4s"    %% "http4s-ember-server" % http4sVersion,
  "org.http4s"    %% "http4s-scala-xml"    % http4sVersion,
  "org.http4s"    %% "http4s-dsl"          % http4sVersion,
  "ch.qos.logback" % "logback-classic"     % logbackVersion,
  "org.tpolecat"  %% "doobie-postgres"     % doobieVersion, // includes org.postgresql.Driver
  "org.tpolecat"  %% "doobie-hikari"       % doobieVersion,
)

enablePlugins(JavaAppPackaging, DockerPlugin)

Compile / mainClass := Some("com.mitrakoff.self.tommylingo.Main")
Docker / packageName := "mitrakov/tommylingo"
dockerBaseImage := "adoptopenjdk:11-jre-hotspot"
dockerExposedPorts ++= Seq(8080)
