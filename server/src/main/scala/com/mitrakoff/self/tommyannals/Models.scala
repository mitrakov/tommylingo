package com.mitrakoff.self.tommyannals

import io.circe.{Codec, Decoder, Encoder}
import io.circe.generic.semiauto.{deriveCodec, deriveDecoder, deriveEncoder}

import java.time.LocalDate

case class Chronicle(date: Option[LocalDate], paramId: Int, valueNum: Option[Double], valueStr: Option[String], comment: Option[String])
case class ChronicleApi(date: Option[LocalDate], paramName: String, valueNum: Option[Double], valueStr: Option[String], comment: Option[String]):
  def toModel(paramId: Int): Chronicle = Chronicle(this.date, paramId, this.valueNum, this.valueStr, this.comment)

object Chronicle:
  given Encoder[Chronicle] = deriveEncoder

object ChronicleApi:
  given Decoder[ChronicleApi] = deriveDecoder
