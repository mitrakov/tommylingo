package com.mitrakoff.self.tommypass

import io.circe.{Decoder, Encoder}
import io.circe.generic.semiauto.{deriveDecoder, deriveEncoder}

case class PassItem(passId: Long, resource: String, login: String, password: String, note: String)
case class ResourcesList(resources: List[String])

object PassItem:
  given Decoder[PassItem] = deriveDecoder

object ResourcesList:
  given Encoder[ResourcesList] = deriveEncoder
