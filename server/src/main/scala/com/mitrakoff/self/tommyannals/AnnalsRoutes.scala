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

  val routes: HttpRoutes[F] =
    import cats.implicits.{toFlatMapOps, toFunctorOps}
    import org.http4s.syntax.header.http4sHeaderSyntax

    val onFailure: AuthedRoutes[String, F] = Kleisli(req => OptionT.liftF(Forbidden(req.context)))
    val authUser: Kleisli[F, Request[F], Either[String, Id]] = Kleisli { request =>
      val either = for {
        token <- request.headers.get[Authorization].map(_.value.toLowerCase.replace("bearer ", "")).toRight(s"Authorization header not found")
        result <- authService.isTokenValid(token)
      } yield result
      implicitly[Applicative[F]].pure(either)
    }

    AuthMiddleware(authUser, onFailure).apply(AuthedRoutes.of {
      case GET -> Root / `annals` / "schema" as userId =>
        given EntityEncoder[F, List[EventParamResponse]] = jsonEncoderOf
        for {
          evParams <- annalsService.getEventsAndParams(userId)
          response <- Ok(evParams)
        } yield response

      case GET -> Root / `annals` / date as userId =>
        given EntityEncoder[F, List[ChronicleResponse]] = jsonEncoderOf
        Try(LocalDate.parse(date)) match
          case Failure(error) => BadRequest(s"Cannot parse date: $date (${error.getMessage})")
          case Success(parsed) => for {
            list <- annalsService.getAllForDate(userId, parsed)
            response <- Ok(list)
          } yield response

      case req@POST -> Root / `annals` as userId =>
        given EntityDecoder[F, ChronicleAddRequest] = jsonOf
        for {
          request <- req.req.as[ChronicleAddRequest]
          eventIdOpt <- annalsService.getEventIdByName(userId, request.eventName)
          paramIdOpt <- annalsService.getParamIdByName(userId, eventIdOpt.getOrElse(-1), request.paramName)
          response <- paramIdOpt.fold(NotFound(s"Event/Param not found: ${request.eventName}/${request.paramName}")) { paramId =>
            annalsService.add(request, paramId).flatMap(rows => Ok(s"$rows row(s) added"))
          }
        } yield response

      case DELETE -> Root / `annals` as userId => Ok(s"DEL: $userId")
    })
