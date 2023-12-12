package com.mitrakoff.self.tommyannals

import io.circe.{Decoder, Encoder}
import io.circe.generic.semiauto.{deriveCodec, deriveDecoder, deriveEncoder}

import java.time.LocalDate

type Id = Int

case class ChronicleResponse(date: LocalDate, eventName: String, paramName: String, valueNum: Option[Double], valueStr: Option[String], comment: Option[String])
case class ChronicleAddRequest(date: LocalDate, eventName: String, paramName: String, valueNum: Option[Double], valueStr: Option[String], comment: Option[String])

object ChronicleResponse:
  given Encoder[ChronicleResponse] = deriveEncoder

object ChronicleAddRequest:
  given Decoder[ChronicleAddRequest] = deriveDecoder
