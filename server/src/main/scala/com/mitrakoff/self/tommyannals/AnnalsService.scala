package com.mitrakoff.self.tommyannals

import java.time.LocalDate

class AnnalsService[F[_]](dao: AnnalsDao[F]):
  def getAllForDate(userId: Int, date: LocalDate): F[List[Chronicle]] = dao.fetchAllForDate(userId, date)

  def add(item: Chronicle): F[Int] = dao.insert(item)

  def getParamIdByName(userId: Int, paramName: String) = dao.findParamId(userId, paramName)
