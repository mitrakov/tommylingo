package com.mitrakoff.self.tommyannals

import java.time.LocalDate

class AnnalsService[F[_]](dao: AnnalsDao[F]):
  def getAllForDate(userId: Id, date: LocalDate): F[List[ChronicleResponse]] = dao.fetchAllForDate(userId, date)

  def add(r: ChronicleAddRequest, paramId: Id): F[Int] = dao.insert(r.date, paramId, r.valueNum, r.valueStr, r.comment)

  def getEventIdByName(userId: Id, eventName: String) = dao.findEventId(userId, eventName)

  def getParamIdByName(userId: Id, eventId: Id, paramName: String) = dao.findParamId(userId, eventId, paramName)
