package com.mitrakoff.self.tommyannals

import com.mitrakoff.self.Db
import com.mitrakoff.self.tommypass.PassItem
import doobie.implicits.toSqlInterpolator
import java.time.LocalDate

class AnnalsDao[F[_]](db: Db[F]):
  def fetchAllForDate(userId: Int, date: LocalDate): F[List[Chronicle]] =
    import doobie.implicits.javatimedrivernative._
    db.run(sql"""SELECT date, param_id, value_num, value_str, comment
                 INNER JOIN param USING(param_id)
                 INNER JOIN event USING(event_id)
                 FROM annals.chronicle
                 WHERE date = $date AND userId = $userId;""".query[Chronicle].to[List]
    )

  def insert(item: Chronicle): F[Int] =
    import doobie.implicits.javatimedrivernative._
    db.run(sql"""INSERT INTO annals.chronicle (date, param_id, value_num, value_str, comment)
                 VALUES (${item.date.getOrElse(LocalDate.now())}, ${item.paramId}, ${item.valueNum}, ${item.valueStr}, ${item.comment});""".update.run
    )

  def findParamId(userId: Int, paramName: String): F[Option[Int]] =
    db.run(
      sql"""SELECT param_id FROM param INNER JOIN event USING(event_id) WHERE user_id = $userId AND param.name = $paramName;""".query[Int].option
    )
