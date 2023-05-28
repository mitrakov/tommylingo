package com.mitrakoff.self.tommypass

import io.circe.{Codec, Encoder}
import io.circe.generic.semiauto.{deriveCodec, deriveEncoder}

case class PassItem(id: Long, resource: String, login: String, password: String, note: Option[String])
case class ResourcesList(resources: List[String])

object PassItem:
  given Codec[PassItem] = deriveCodec

object ResourcesList:
  given Encoder[ResourcesList] = deriveEncoder
