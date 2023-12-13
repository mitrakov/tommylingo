package com.mitrakoff.self.tommyannals

import com.mitrakoff.self.Db
import doobie.implicits.toSqlInterpolator
import java.time.LocalDate

// notes: you must specify schema name (`annals.`) explicitly!
class AnnalsDao[F[_]](db: Db[F]):
  case class Chronicle(date: LocalDate, eventName: String, paramName: String, valueNum: Option[Double], valueStr: Option[String], comment: Option[String])
  case class EventParam(eventName: String, eventDescription: Option[String], name: String, description: Option[String], `type`: String, defaultValue: Option[String])

  def fetchAllForDate(userId: Id, date: LocalDate): F[List[Chronicle]] =
    import doobie.implicits.javatimedrivernative._
    db.run(sql"""SELECT date, event.name, param.name, value_num, value_str, comment
                 FROM annals.chronicle
                 INNER JOIN annals.param USING(param_id)
                 INNER JOIN annals.event USING(event_id)
                 WHERE date = $date AND user_id = $userId;""".query[Chronicle].to[List]
    )

  def fetchEventsAndParams(userId: Id): F[List[EventParam]] =
    db.run(sql"""SELECT event.name, event.description, param.name, param.description, param.type, param.default_value
                 FROM annals.event
                 INNER JOIN annals.param USING(event_id)
                 WHERE user_id = $userId;""".query[EventParam].to[List]
    )

  def insert(date: LocalDate, paramId: Id, valueNum: Option[Double], valueStr: Option[String], comment: Option[String]): F[Int] =
    import doobie.implicits.javatimedrivernative._
    db.run(sql"""INSERT INTO annals.chronicle (date, param_id, value_num, value_str, comment)
                 VALUES ($date, $paramId, $valueNum, $valueStr, $comment);""".update.run
    )

  def findEventId(userId: Id, eventName: String): F[Option[Id]] =
    db.run(
      sql"""SELECT event_id FROM annals.event WHERE user_id = $userId AND name = $eventName;""".query[Id].option
    )

  def findParamId(userId: Id, eventId: Id, paramName: String): F[Option[Id]] =
    db.run(
      sql"""SELECT param_id FROM annals.param
            INNER JOIN annals.event USING(event_id)
            WHERE user_id = $userId AND event_id = $eventId AND param.name = $paramName;""".query[Id].option
    )
