val http4sVersion = "0.23.13"
val logbackVersion = "1.4.6"
val doobieVersion = "1.0.0-RC2"

lazy val root = (project in file("."))
  .settings(
    organization := "com.mitrakoff.self",
    name := "tommylingo",
    version := "0.0.1",
    scalaVersion := "3.2.1",
    libraryDependencies ++= Seq(
      "org.http4s"      %% "http4s-ember-server" % http4sVersion,
      "org.http4s"      %% "http4s-circe"        % http4sVersion,
      "org.http4s"      %% "http4s-scala-xml"    % http4sVersion,
      "org.http4s"      %% "http4s-dsl"          % http4sVersion,
      "ch.qos.logback"  %  "logback-classic"     % logbackVersion,
      "org.tpolecat" %% "doobie-postgres" % doobieVersion,
      "org.tpolecat" %% "doobie-hikari" % doobieVersion,
    ),
  )
