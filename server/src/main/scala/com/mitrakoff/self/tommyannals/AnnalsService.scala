package com.mitrakoff.self.tommyannals

import java.time.LocalDate

class AnnalsService[F[_]](dao: AnnalsDao[F]):
  def getAllForDate(userId: Int, date: LocalDate): F[List[ChronicleResponse]] = dao.fetchAllForDate(userId, date)

  def add(r: ChronicleAddRequest, paramId: Int): F[Int] = dao.insert(r.date, paramId, r.valueNum, r.valueStr, r.comment)

  def getParamIdByName(userId: Int, paramName: String) = dao.findParamId(userId, paramName)
