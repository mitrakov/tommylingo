package com.mitrakoff.self.tommyannals

import com.mitrakoff.self.Db
import doobie.implicits.toSqlInterpolator
import java.time.LocalDate

// notes: you must specify schema name (`annals.`) explicitly!
class AnnalsDao[F[_]](db: Db[F]):
  def fetchAllForDate(userId: Int, date: LocalDate): F[List[ChronicleResponse]] =
    import doobie.implicits.javatimedrivernative._
    db.run(sql"""SELECT date, event.name, param.name, value_num, value_str, comment
                 FROM annals.chronicle
                 INNER JOIN annals.param USING(param_id)
                 INNER JOIN annals.event USING(event_id)
                 WHERE date = $date AND user_id = $userId;""".query[ChronicleResponse].to[List]
    )

  def insert(date: LocalDate, paramId: Int, valueNum: Option[Double], valueStr: Option[String], comment: Option[String]): F[Int] =
    import doobie.implicits.javatimedrivernative._
    db.run(sql"""INSERT INTO annals.chronicle (date, param_id, value_num, value_str, comment)
                 VALUES ($date, $paramId, $valueNum, $valueStr, $comment);""".update.run
    )

  def findParamId(userId: Int, paramName: String): F[Option[Int]] =
    db.run(
      sql"""SELECT param_id FROM annals.param INNER JOIN event USING(event_id) WHERE user_id = $userId AND param.name = $paramName;""".query[Int].option
    )
