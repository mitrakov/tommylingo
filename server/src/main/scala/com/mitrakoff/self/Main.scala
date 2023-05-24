package com.mitrakoff.self

import cats.effect.{Async, IO, IOApp, Resource}
import com.comcast.ip4s.{ipv4, port}
import com.mitrakoff.self.tommylingo.{LingoDao, LingoRoutes, LingoService}
import com.mitrakoff.self.tommypass.{PassDao, PassRoutes, PassService}
import doobie.hikari.HikariTransactor
import doobie.util.ExecutionContexts
import org.http4s.HttpApp
import org.http4s.ember.server.EmberServerBuilder
import org.http4s.server.middleware.Logger

object Main extends IOApp.Simple:
  val run: IO[Unit] = this.run[IO]

  private def run[F[_] : Async]: F[Nothing] = {
    import cats.implicits.toSemigroupKOps
    val authService: AuthService[F] = AuthService()
    createTransactor() use { tx =>
      val db: Db[F] = Db(tx)
      val lingoDao: LingoDao[F] = LingoDao(db)
      val passDao: PassDao[F] = PassDao(db)
      val lingoService: LingoService[F] = LingoService(lingoDao)
      val passService: PassService[F] = PassService(passDao)
      val lingoRoutes: LingoRoutes[F] = LingoRoutes(lingoService)
      val passRoutes: PassRoutes[F] = PassRoutes(authService, passService)
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
