package com.mitrakoff.self

import cats.effect.kernel.MonadCancelThrow
import doobie.ConnectionIO
import doobie.util.transactor.Transactor

class Db[F[_]: MonadCancelThrow](tx: Transactor[F]):
  import doobie.implicits.toConnectionIOOps
  def run[A](program: ConnectionIO[A]): F[A] = program.transact(tx)
