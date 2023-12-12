package com.mitrakoff.self.tommyannals

import cats.Functor
import java.time.LocalDate

class AnnalsService[F[_]: Functor](dao: AnnalsDao[F]):
  def getAllForDate(userId: Id, date: LocalDate): F[List[ChronicleResponse]] = dao.fetchAllForDate(userId, date)

  def getEventsAndParams(userId: Id): F[List[EventParamResponse]] = {
    import cats.implicits.toFunctorOps
    dao.fetchEventsAndParams(userId) map { params =>
      val grouped = params.groupMap(p => p.eventName -> p.eventDescription) (p => Param(p.name, p.description, p.`type`, p.defaultValue))
      grouped.map { case ((eventName, eventDescription), params) => EventParamResponse(eventName, eventDescription, params) }.toList
    }
  }

  def add(r: ChronicleAddRequest, paramId: Id): F[Int] = dao.insert(r.date, paramId, r.valueNum, r.valueStr, r.comment)

  def getEventIdByName(userId: Id, eventName: String): F[Option[Id]] = dao.findEventId(userId, eventName)

  def getParamIdByName(userId: Id, eventId: Id, paramName: String): F[Option[Id]] = dao.findParamId(userId, eventId, paramName)
