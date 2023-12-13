package com.mitrakoff.self.tommyannals

import io.circe.{Decoder, Encoder}
import io.circe.generic.semiauto.{deriveCodec, deriveDecoder, deriveEncoder}

import java.time.LocalDate

type Id = Int

// === Chronicle Add Request (POST) ===
case class ChronicleAddRequestParam(name: String, valueNum: Option[Double], valueStr: Option[String], comment: Option[String])
case class ChronicleAddRequest(date: LocalDate, eventName: String, params: List[ChronicleAddRequestParam])

// === Chronicle Response (GET) ===
case class ChronicleResponseParam(paramName: String, valueNum: Option[Double], valueStr: Option[String], comment: Option[String])
case class ChronicleResponseEvent(eventName: String, params: List[ChronicleResponseParam])
case class ChronicleResponse(date: LocalDate, events: List[ChronicleResponseEvent])

// === Schema Response ===
case class SchemaResponseParam(name: String, description: Option[String], `type`: String, defaultValue: Option[String])
case class SchemaResponse(eventName: String, eventDescription: Option[String], params: List[SchemaResponseParam])
// ===

// === CODECS ===
object SchemaResponse:
  given Encoder[SchemaResponseParam] = deriveEncoder
  given Encoder[SchemaResponse] = deriveEncoder

object ChronicleResponse:
  given Encoder[ChronicleResponseParam] = deriveEncoder
  given Encoder[ChronicleResponseEvent] = deriveEncoder
  given Encoder[ChronicleResponse] = deriveEncoder

object ChronicleAddRequest:
  given Decoder[ChronicleAddRequestParam] = deriveDecoder
  given Decoder[ChronicleAddRequest] = deriveDecoder
