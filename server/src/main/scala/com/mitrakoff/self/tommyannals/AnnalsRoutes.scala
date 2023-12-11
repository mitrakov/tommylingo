package com.mitrakoff.self.tommyannals

import cats.data.{Kleisli, OptionT}
import cats.effect.Concurrent
import cats.Applicative
import com.mitrakoff.self.AuthService
import org.http4s.circe.{jsonEncoderOf, jsonOf}
import org.http4s.dsl.Http4sDsl
import org.http4s.headers.Authorization
import org.http4s.server.AuthMiddleware
import org.http4s.{AuthedRoutes, EntityDecoder, EntityEncoder, HttpRoutes, Request}
import java.time.LocalDate
import scala.util.{Failure, Success, Try}

class AnnalsRoutes[F[_]: Concurrent](authService: AuthService[F], annalsService: AnnalsService[F]) extends Http4sDsl[F]:
  private final val annals: String = "annals"
  given EntityEncoder[F, List[Chronicle]] = jsonEncoderOf[F, List[Chronicle]]
  given EntityDecoder[F, ChronicleApi] = jsonOf[F, ChronicleApi]

  val routes: HttpRoutes[F] =
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
      case GET -> Root / `annals` / date as userId =>
        Try(LocalDate.parse(date)) match
          case Failure(error) => BadRequest(s"Cannot parse date: $date ($error)")
          case Success(parsed) => for {
            list <- annalsService.getAllForDate(userId, parsed)
            response <- Ok(list)
          } yield response
      case req@POST -> Root / `annals` as userId =>
        val recordF = req.req.as[ChronicleApi]
        val ff = for {
          record <- recordF
          paramIdOpt <- annalsService.getParamIdByName(userId, record.paramName)
        } yield paramIdOpt match {
          case None => NotFound(s"Param not found: ${record.paramName}")
          case Some(paramId) =>
            val chronicle = record.toModel(paramId)
            for {
              rows <- annalsService.add(chronicle)
              response <- Ok(s"$rows row(s) added")
            } yield response
        }
        ff.flatten
      case PUT -> Root / `annals` as userId => Ok(s"PUT: $userId")
      case DELETE -> Root / `annals` as userId => Ok(s"DEL: $userId")
    })
