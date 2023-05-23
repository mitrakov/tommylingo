package com.mitrakoff.self.tommypass

import io.circe.Decoder
import io.circe.generic.semiauto.deriveDecoder
import org.http4s.EntityDecoder

case class PassItem(passId: Long, resource: String, login: String, password: String, note: String)

case object PassItem:
  given Decoder[PassItem] = deriveDecoder
