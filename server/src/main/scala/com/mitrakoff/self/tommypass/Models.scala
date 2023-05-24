package com.mitrakoff.self.tommypass

import io.circe.Encoder
import io.circe.generic.semiauto.deriveEncoder

case class PassItem(id: Long, resource: String, login: String, password: String, note: Option[String])
case class ResourcesList(resources: List[String])

object PassItem:
  given Encoder[PassItem] = deriveEncoder

object ResourcesList:
  given Encoder[ResourcesList] = deriveEncoder
