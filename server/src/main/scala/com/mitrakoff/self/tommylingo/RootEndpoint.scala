package com.mitrakoff.self.tommylingo

import cats.effect.Async
import cats.implicits.*
import org.http4s.{EntityDecoder, EntityEncoder, HttpRoutes, MediaType}
import org.http4s.dsl.Http4sDsl
import org.http4s.scalaxml.{xml, xmlEncoder}

class RootEndpoint[F[_]: Async](service: RootService[F]) extends Http4sDsl[F]:
  given EntityDecoder[F, DictKey] = xml map { elem =>
    val langCode = (elem \ "langCode").text
    val key = (elem \ "key").text
    DictKey(1, langCode, key)
  }

  given EntityDecoder[F, Dict] =
    EntityDecoder.decodeBy(MediaType.text.xml, MediaType.text.html, MediaType.application.xml) { msg =>
      for {
        dictKey <- implicitly[EntityDecoder[F, DictKey]].decode(msg, strict = false)
        translation <- xml.map { elem => (elem \ "translation").text }.decode(msg, strict = false)
      } yield Dict(dictKey, translation)
    }

  given keysEncoder: EntityEncoder[F, List[String]] =
    xmlEncoder contramap { list => <keys>{list map(s => {<key>{s}</key>})}</keys> }

  given translationsEncoder: EntityEncoder[F, List[(String, String)]] =
    xmlEncoder contramap { list => <result>{list map {case (k, v) => <item key={k}>{v}</item> }}</result> }

  val routes: HttpRoutes[F] = HttpRoutes.of {
    case GET -> Root / "lingo" / "keys" / langCode =>
      Ok(service.getAllKeys(1, langCode))
    case GET -> Root / "lingo" / "translations" / langCode =>
      Ok(service.getTranslations(1, langCode))
    case req @ POST -> Root / "lingo" =>
      req.as[Dict].flatMap { dict =>
        service.upsert(dict) *> Ok(<result>ok</result>)
      }
    case req @ DELETE -> Root / "lingo" =>
      req.as[DictKey].flatMap { dictKey =>
        service.remove(dictKey) *> Ok(<result>ok</result>)
      }
  }
