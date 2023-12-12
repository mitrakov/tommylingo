package com.mitrakoff.self.tommyannals

import io.circe.{Decoder, Encoder}
import io.circe.generic.semiauto.{deriveCodec, deriveDecoder, deriveEncoder}

import java.time.LocalDate

type Id = Int

case class ChronicleResponse(date: LocalDate, eventName: String, paramName: String, valueNum: Option[Double], valueStr: Option[String], comment: Option[String])
case class ChronicleAddRequest(date: LocalDate, eventName: String, paramName: String, valueNum: Option[Double], valueStr: Option[String], comment: Option[String])
case class EventParam(eventName: String, eventDescription: Option[String], name: String, description: Option[String], `type`: String, defaultValue: Option[String])
case class Param(name: String, description: Option[String], `type`: String, defaultValue: Option[String])
case class EventParamResponse(eventName: String, eventDescription: Option[String], params: List[Param])

object ChronicleResponse:
  given Encoder[ChronicleResponse] = deriveEncoder

object ChronicleAddRequest:
  given Decoder[ChronicleAddRequest] = deriveDecoder

object Param:
  given Encoder[Param] = deriveEncoder

object EventParamResponse:
  given Encoder[EventParamResponse] = deriveEncoder
