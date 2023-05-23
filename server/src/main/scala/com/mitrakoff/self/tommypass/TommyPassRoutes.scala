package com.mitrakoff.self.tommypass

import cats.data.{Kleisli, OptionT}
import cats.effect.{Async, Concurrent, Sync}
import cats.{Applicative, Monad}
import com.mitrakoff.self.AuthService
import com.mitrakoff.self.tommypass.PassItem
import org.http4s.circe.*
import org.http4s.dsl.Http4sDsl
import org.http4s.headers.Authorization
import org.http4s.server.AuthMiddleware
import org.http4s.{AuthedRequest, AuthedRoutes, EntityDecoder, HttpRoutes, Request, Response}

class TommyPassRoutes[F[_]: Concurrent](authService: AuthService[F]) extends Http4sDsl[F]:
  given EntityDecoder[F, PassItem] = jsonOf[F, PassItem]

  def routes: HttpRoutes[F] = {
    import cats.implicits.{toFlatMapOps, toFunctorOps}
    import org.http4s.syntax.header.http4sHeaderSyntax

    val onFailure: AuthedRoutes[String, F] = Kleisli(req => OptionT.liftF(Forbidden(req.authInfo)))
    val authUser: Kleisli[F, Request[F], Either[String, Long]] = Kleisli { request =>
      val either = for {
        token <- request.headers.get[Authorization].map(_.value.toLowerCase.replace("bearer ", "")).toRight(s"Authorization header not found")
        result <- authService.isTokenValid(token)
      } yield result
      implicitly[Applicative[F]].pure(either) // we must wrap it into effect F for possible changes that might require IO operations
    }

    AuthMiddleware(authUser, onFailure).apply(AuthedRoutes.of[Long, F] {
      case GET -> Root / "pass" / key as userId =>
        Ok(s"$key: $userId")
      case req@POST -> Root / "pass" as userId =>
        for {
          data <- req.req.as[PassItem]
          response <- Ok(data.login)
        } yield response
      case PUT    -> Root / "pass" as userId => Ok(s"key: userId")
      case DELETE -> Root / "pass" as userId => Ok(s"key: userId")
    })
  }
