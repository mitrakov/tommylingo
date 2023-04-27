package com.mitrakoff.self.tommylingo

import cats.effect.Async
import doobie.ConnectionIO
import doobie.util.transactor.Transactor
import doobie.implicits.toConnectionIOOps

class Db[F[_]: Async](tx: Transactor[F]):
  def run[A](program: ConnectionIO[A]): F[A] = program.transact(tx)
