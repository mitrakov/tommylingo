package com.mitrakoff.self.tommyannals

import cats.{Applicative, Monad}
import java.time.LocalDate

class AnnalsService[F[_]: Monad](dao: AnnalsDao[F]):
  def getAllForDate(userId: Id, date: LocalDate): F[List[Chronicle]] =
    import cats.implicits.toFunctorOps
    dao.fetchAllForDate(userId, date).map( _.map(c => Chronicle(c.date, c.eventName, c.params, c.comment)) )

  def getSchema(userId: Id): F[List[SchemaResponse]] =
    import cats.implicits.toFunctorOps
    dao.fetchSchema(userId) map { list =>
      val grouped = list.groupMap(p => p.eventName -> p.eventDescription) (p => SchemaResponseParam(p.name, p.description, p.`type`, p.unit, p.defaultValue))
      grouped.map { case ((eventName, eventDescription), params) => SchemaResponse(eventName, eventDescription, params) }.toList
    }

  def add(userId: Id, r: Chronicle): F[Int] =
    import cats.implicits.toFlatMapOps
    dao.findEventId(userId, r.eventName) flatMap { eventIdOpt =>
      eventIdOpt match
        case Some(eventId) => dao.insert(r.date, eventId, r.params, r.comment)
        case None => implicitly[Applicative[F]].pure(0)
    }
