package com.mitrakoff.self

import cats.effect.{Async, IO, IOApp, Resource}
import com.comcast.ip4s.{ipv4, port}
import com.mitrakoff.self.tommyannals.{AnnalsDao, AnnalsRoutes, AnnalsService}
import com.mitrakoff.self.tommylingo.{LingoDao, LingoRoutes, LingoService}
import doobie.hikari.HikariTransactor
import doobie.util.ExecutionContexts
import org.http4s.HttpApp
import org.http4s.ember.server.EmberServerBuilder
import org.http4s.server.middleware.Logger

object Main extends IOApp.Simple:
  private val password = sys.env.getOrElse("DB_PASSWORD", throw new IllegalStateException("Please provide DB_PASSWORD env variable"))
  val run: IO[Unit] = this.run[IO]

  private def run[F[_]: Async]: F[Nothing] = {
    import cats.implicits.toSemigroupKOps
    val authService: AuthService[F] = AuthService()
    createTransactor() use { tx =>
      val db: Db[F] = Db(tx)
      val lingoDao: LingoDao[F] = LingoDao(db)
      val annalsDao: AnnalsDao[F] = AnnalsDao(db)
      val lingoService: LingoService[F] = LingoService(lingoDao)
      val annalsService: AnnalsService[F] = AnnalsService(annalsDao)
      val lingoRoutes: LingoRoutes[F] = LingoRoutes(lingoService)
      val annalsRoutes: AnnalsRoutes[F] = AnnalsRoutes(authService, annalsService)
      val httpApp: HttpApp[F] = (lingoRoutes.routes <+> annalsRoutes.routes).orNotFound
      val finalHttpApp: HttpApp[F] = Logger.httpApp(logHeaders = true, logBody = true)(httpApp)

      EmberServerBuilder.default[F].withHost(ipv4"0.0.0.0").withPort(port"8080").withHttpApp(finalHttpApp).build.useForever
    }
  }

  private def createTransactor[F[_]: Async](
     driver: String = "org.postgresql.Driver",
     url: String = "jdbc:postgresql://mitrakoff.com:5432/varlam",
     user: String = "mitrakov",
   ): Resource[F, HikariTransactor[F]] = {
    for {
      connectEc <- ExecutionContexts.fixedThreadPool[F](32)
      xa <- HikariTransactor.newHikariTransactor[F](driver, url, user, password, connectEc)
    } yield xa
  }
