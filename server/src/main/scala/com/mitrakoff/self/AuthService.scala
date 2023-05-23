package com.mitrakoff.self

class AuthService[F[_]] {
  def isTokenValid(token: String): Either[String, Long] = {
    // TODO WTF, bro? replace with https://pastebin.com/zUjAgTdw
    Either.cond(token == "555", 1, "Invalid Auth")
  }
}
