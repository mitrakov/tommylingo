package com.mitrakoff.self.tommypass

import io.circe.Decoder
import io.circe.generic.semiauto.deriveDecoder

case class PassItem(passId: Long, resource: String, login: String, password: String, note: String)

object PassItem:
  given Decoder[PassItem] = deriveDecoder
