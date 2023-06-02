package com.mitrakoff.self.tommylingo

import cats.effect.Async
import cats.implicits.{toFlatMapOps, catsSyntaxApply}
import org.http4s.{EntityDecoder, EntityEncoder, HttpRoutes}
import org.http4s.dsl.Http4sDsl
import org.http4s.scalaxml.{xmlDecoder, xmlEncoder}

class LingoRoutes[F[_]: Async](service: LingoService[F]) extends Http4sDsl[F]:
  given EntityDecoder[F, DictKey] = xmlDecoder map { elem =>
    val langCode = (elem \ "langCode").text.trim
    val key = (elem \ "key").text.trim
    DictKey(1, langCode, key)
  }

  given EntityDecoder[F, Dict] = xmlDecoder map { elem =>
    // note: do NOT reuse other decoders! "xmlDecoder.map" may be called only once!
    val langCode = (elem \ "langCode").text.trim
    val key = (elem \ "key").text.trim
    val translation = (elem \ "translation").text.trim
    Dict(DictKey(1, langCode, key), translation)
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
