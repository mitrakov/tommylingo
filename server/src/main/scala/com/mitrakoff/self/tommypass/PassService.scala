package com.mitrakoff.self.tommypass

import cats.Functor

class PassService[F[_]: Functor](dao: PassDao[F]) {
  import cats.implicits.toFunctorOps
  def getAllResources(userId: Int): F[ResourcesList] = dao.fetchAllResources(userId) map ResourcesList.apply
}
