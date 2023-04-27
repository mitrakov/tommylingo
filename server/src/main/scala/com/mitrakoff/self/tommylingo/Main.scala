package com.mitrakoff.self.tommylingo

import cats.effect.{Async, ExitCode, IO, IOApp, Resource}
import org.http4s.HttpApp
import org.http4s.ember.server.EmberServerBuilder
import org.http4s.server.middleware.Logger
import cats.data.Kleisli
import cats.syntax.all.*
import com.comcast.ip4s.*
import doobie.util.ExecutionContexts
import doobie.hikari._
import org.http4s.*
import org.http4s.ember.server.EmberServerBuilder
import org.http4s.implicits.*
import org.http4s.server.middleware.Logger

object Main extends IOApp.Simple:
  val run: IO[Unit] = this.run[IO]

  private def run[F[_] : Async]: F[Nothing] = {
    createTransactor() use { tx =>
      val db: Db[F]= Db(tx)
      val dao: Dao[F]= Dao(db)
      val service: RootService[F]= RootService(dao)
      val rootEndpoint: RootEndpoint[F]= RootEndpoint(service)
      val httpApp: HttpApp[F]= (rootEndpoint.routes).orNotFound
      val finalHttpApp: HttpApp[F]= Logger.httpApp(logHeaders = true, logBody = true)(httpApp)

      EmberServerBuilder.default[F].withHost(ipv4"0.0.0.0").withPort(port"8080").withHttpApp(finalHttpApp).build.useForever
    }
  }

  private def createTransactor[F[_]: Async](
     driver: String = "org.postgresql.Driver",
     url: String = "jdbc:postgresql://localhost:5432/postgres",
     user: String = "postgres",
     password: String = "postgres",
   ): Resource[F, HikariTransactor[F]] = {
    for {
      connectEc <- ExecutionContexts.fixedThreadPool[F](32)
      xa <- HikariTransactor.newHikariTransactor[F](driver, url, user, password, connectEc)
    } yield xa
  }
