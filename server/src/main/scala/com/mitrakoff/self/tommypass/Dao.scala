package com.mitrakoff.self.tommypass

import com.mitrakoff.self.Db
import doobie.implicits.toSqlInterpolator

/*
CREATE TABLE pass.main (
 id SERIAL NOT NULL PRIMARY KEY,
 user_id INT NOT NULL,
 resource VARCHAR(255) NOT NULL,
 login VARCHAR(128) NOT NULL,
 password VARCHAR(128) NOT NULL,
 note VARCHAR(255) NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX main_uk ON pass.main (user_id, resource, login);
*/

class Dao[F[_]](db: Db[F]):
  def fetchWithLimit(userId: Int, langCode: String, limit: Int): F[List[(String, String)]] =
    db.run(sql"""SELECT key, translation FROM lingo.dict WHERE user_id = $userId AND lang_code = $langCode ORDER BY random() LIMIT $limit;""".query[(String, String)].to[List])

//  def fetchAllKeys(userId: Int, langCode: String): F[List[String]] =
//    db.run(sql"""SELECT key FROM lingo.dict WHERE user_id = $userId AND lang_code = $langCode;""".query[String].to[List])
//
//  def persist(dict: PassItem): F[Int] =
//    db.run(sql"""INSERT INTO lingo.dict (user_id, lang_code, key, translation)
//           VALUES (${dict.dictKey.userId}, ${dict.dictKey.langCode}, ${dict.dictKey.key}, ${dict.translation})
//           ON CONFLICT (user_id, lang_code, key) DO UPDATE SET translation = ${dict.translation}
//           ;""".update.run)
//
//  def delete(id: Long): F[Int] =
//    db.run(sql"""DELETE FROM lingo.dict WHERE user_id = ${dictKey.userId} AND lang_code = ${dictKey.langCode} AND key = ${dictKey.key};""".update.run)
