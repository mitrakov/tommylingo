package com.mitrakoff.self.tommypass

import cats.data.{Kleisli, OptionT}
import cats.effect.Concurrent
import cats.Applicative
import com.mitrakoff.self.AuthService
import com.mitrakoff.self.tommypass.PassItem
import org.http4s.circe.{jsonOf, jsonEncoderOf}
import org.http4s.dsl.Http4sDsl
import org.http4s.headers.Authorization
import org.http4s.server.AuthMiddleware
import org.http4s.{AuthedRoutes, EntityDecoder, EntityEncoder, HttpRoutes, Request}

class PassRoutes[F[_]: Concurrent](authService: AuthService[F], passService: PassService[F]) extends Http4sDsl[F]:
  //given EntityDecoder[F, PassItem] = jsonOf[F, PassItem]
  given EntityEncoder[F, ResourcesList] = jsonEncoderOf[F, ResourcesList]
  given EntityEncoder[F, PassItem] = jsonEncoderOf[F, PassItem]

  def routes: HttpRoutes[F] = {
    import cats.implicits.{toFlatMapOps, toFunctorOps}
    import org.http4s.syntax.header.http4sHeaderSyntax

    val onFailure: AuthedRoutes[String, F] = Kleisli(req => OptionT.liftF(Forbidden(req.context)))
    val authUser: Kleisli[F, Request[F], Either[String, Int]] = Kleisli { request =>
      val either = for {
        token <- request.headers.get[Authorization].map(_.value.toLowerCase.replace("bearer ", "")).toRight(s"Authorization header not found")
        result <- authService.isTokenValid(token)
      } yield result
      implicitly[Applicative[F]].pure(either)
    }

    AuthMiddleware(authUser, onFailure).apply(AuthedRoutes.of {
      case GET -> Root / "pass" / "resources" as userId =>
        for {
          list <- passService.getAllResources(userId)
          response <- Ok(list)
        } yield response
      case GET -> Root / "pass" / resource as userId =>
        for {
          opt <- passService.getResource(userId, resource)
          response <- opt match // TODO should return a list (not option)
            case Some(item) => Ok(item)
            case None => NotFound("Resource not found")
        } yield response
//      case req@POST -> Root / "pass" as userId =>
//        for {
//          data <- req.req.as[PassItem]
//          response <- Ok(data.login)
//        } yield response
      case PUT    -> Root / "pass" as userId => Ok(s"key: userId")
      case DELETE -> Root / "pass" as userId => Ok(s"key: userId")
    })
  }
