package com.mitrakoff.self.tommylingo

import com.mitrakoff.self.Db
import doobie.implicits.toSqlInterpolator

/*
https://www.oracle.com/java/technologies/javase/java8locales.html
CREATE TABLE dict (
 user_id INT NOT NULL,
 lang_code VARCHAR (8) NOT NULL,
 key VARCHAR (128) NOT NULL,
 translation VARCHAR (255) NOT NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (user_id, lang_code, key)
);
*/

class Dao[F[_]](db: Db[F]):
  def fetchWithLimit(userId: Int, langCode: String, limit: Int): F[List[(String, String)]] =
    db.run(sql"""SELECT key, translation FROM lingo.dict WHERE user_id = $userId AND lang_code = $langCode ORDER BY random() LIMIT $limit;""".query[(String, String)].to[List])

  def fetchAllKeys(userId: Int, langCode: String): F[List[String]] =
    db.run(sql"""SELECT key FROM lingo.dict WHERE user_id = $userId AND lang_code = $langCode;""".query[String].to[List])

  def persist(dict: Dict): F[Int] =
    db.run(sql"""INSERT INTO lingo.dict (user_id, lang_code, key, translation)
           VALUES (${dict.dictKey.userId}, ${dict.dictKey.langCode}, ${dict.dictKey.key}, ${dict.translation})
           ON CONFLICT (user_id, lang_code, key) DO UPDATE SET translation = ${dict.translation}
           ;""".update.run)

  def delete(dictKey: DictKey): F[Int] =
    db.run(sql"""DELETE FROM lingo.dict WHERE user_id = ${dictKey.userId} AND lang_code = ${dictKey.langCode} AND key = ${dictKey.key};""".update.run)
