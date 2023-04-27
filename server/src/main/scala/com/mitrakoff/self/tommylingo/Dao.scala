package com.mitrakoff.self.tommylingo

import doobie.ConnectionIO
import doobie.implicits.toSqlInterpolator

class Dao[F[_]](db: Db[F]):
/*
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

  def fetchWithLimit(userId: Int, langCode: String, limit: Int) =
    db.run(sql"""SELECT key, translation FROM dict WHERE user_id = $userId AND lang_code = $langCode LIMIT $limit;""".query[(String, String)].to[List])

  def fetchAllKeys(userId: Int, langCode: String): F[List[String]] =
    db.run(sql"""SELECT key FROM dict WHERE user_id = $userId AND lang_code = $langCode;""".query[String].to[List])

  def persist(dict: Dict): F[Int] =
    db.run(sql"""INSERT INTO dict (user_id, lang_code, key, translation)
           VALUES (${dict.dictKey.userId}, ${dict.dictKey.langCode}, ${dict.dictKey.key}, ${dict.translation});""".update.run)

  def edit(langId: Int, key: String, translation: String): F[Int] =
    db.run(sql"""UPDATE dict SET translation = $translation WHERE userId = 1 AND langId = $langId AND key = $key;""".update.run)

  def delete(dictKey: DictKey): F[Int] =
    db.run(sql"""DELETE FROM dict WHERE user_id = ${dictKey.userId} AND lang_code = ${dictKey.langCode} AND key = ${dictKey.key};""".update.run)
