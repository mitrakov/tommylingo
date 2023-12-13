package com.mitrakoff.self.tommyannals

import cats.Monad
import java.time.LocalDate

class AnnalsService[F[_]: Monad](dao: AnnalsDao[F]):
  def getAllForDate(userId: Id, date: LocalDate): F[ChronicleResponse] =
    import cats.implicits.toFunctorOps
    dao.fetchAllForDate(userId, date) map { list =>
      val grouped = list.groupMap(_.eventName)(ch => ChronicleResponseParam(ch.paramName, ch.valueNum, ch.valueStr, ch.comment))
      val events = grouped.map {case (eventName, params) => ChronicleResponseEvent(eventName, params) }.toList
      ChronicleResponse(date, events)
    }

  def getSchema(userId: Id): F[List[SchemaResponse]] =
    import cats.implicits.toFunctorOps
    dao.fetchEventsAndParams(userId) map { list =>
      val grouped = list.groupMap(p => p.eventName -> p.eventDescription) (p => SchemaResponseParam(p.name, p.description, p.`type`, p.defaultValue))
      grouped.map { case ((eventName, eventDescription), params) => SchemaResponse(eventName, eventDescription, params) }.toList
    }

  def add(userId: Id, r: ChronicleAddRequest): F[Int] =
    import cats.implicits.{toFlatMapOps, toFunctorOps, toTraverseOps}
    dao.findEventId(userId, r.eventName) flatMap { eventIdOpt =>
      val eventId = eventIdOpt.getOrElse(throw new IllegalStateException(s"Event not found: ${r.eventName}"))
      val rowsAdded: F[List[Int]] = r.params traverse { param =>
        dao.findParamId(userId, eventId, param.name) flatMap { paramIdOpt =>
          val paramId = paramIdOpt.getOrElse(throw new IllegalStateException(s"Param not found: ${param.name}"))
          dao.insert(r.date, paramId, param.valueNum, param.valueStr, param.comment)
        }
      }
      rowsAdded map (_.sum)
    }
