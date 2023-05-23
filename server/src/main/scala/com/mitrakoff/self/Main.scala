package com.mitrakoff.self

import cats.effect.{Async, IO, IOApp, Resource}
import com.comcast.ip4s.{ipv4, port}
import com.mitrakoff.self.tommylingo.{Dao, LingoService, LingoRoutes}
import com.mitrakoff.self.tommypass.PassRoutes
import doobie.hikari.HikariTransactor
import doobie.util.ExecutionContexts
import org.http4s.HttpApp
import org.http4s.ember.server.EmberServerBuilder
import org.http4s.server.middleware.Logger

object Main extends IOApp.Simple:
  val run: IO[Unit] = this.run[IO]

  private def run[F[_] : Async]: F[Nothing] = {
    import cats.implicits.toSemigroupKOps
    createTransactor() use { tx =>
      val db: Db[F] = Db(tx)
      val dao: Dao[F] = Dao(db)
      val authService: AuthService[F] = new AuthService()
      val lingoService: LingoService[F] = LingoService(dao)
      val lingoRoutes: LingoRoutes[F] = LingoRoutes(lingoService)
      val passRoutes: PassRoutes[F] = PassRoutes(authService)
      val httpApp: HttpApp[F] = (lingoRoutes.routes <+> passRoutes.routes).orNotFound
      val finalHttpApp: HttpApp[F] = Logger.httpApp(logHeaders = true, logBody = true)(httpApp)

      EmberServerBuilder.default[F].withHost(ipv4"0.0.0.0").withPort(port"8080").withHttpApp(finalHttpApp).build.useForever
    }
  }

  private def createTransactor[F[_]: Async](
     driver: String = "org.postgresql.Driver",
     url: String = "jdbc:postgresql://mitrakoff.com:5432/varlam",
     user: String = "mitrakov",
     password: String = "",
   ): Resource[F, HikariTransactor[F]] = {
    for {
      connectEc <- ExecutionContexts.fixedThreadPool[F](32)
      xa <- HikariTransactor.newHikariTransactor[F](driver, url, user, password, connectEc)
    } yield xa
  }
