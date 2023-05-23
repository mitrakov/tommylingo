package com.mitrakoff.self

import cats.effect.Sync
import doobie.ConnectionIO
import doobie.implicits.toConnectionIOOps
import doobie.util.transactor.Transactor

class Db[F[_]: Sync](tx: Transactor[F]):
  def run[A](program: ConnectionIO[A]): F[A] = program.transact(tx)
