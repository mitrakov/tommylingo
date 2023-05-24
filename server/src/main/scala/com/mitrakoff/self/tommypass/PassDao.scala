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

class PassDao[F[_]](db: Db[F]):
  def fetchAllResources(userId: Int): F[List[String]] =
    db.run(sql"""SELECT resource FROM pass.main WHERE user_id = $userId;""".query[String].to[List])

  def fetchResource(userId: Int, resource: String): F[Option[PassItem]] =
    db.run(sql"""SELECT id, resource, login, password, note FROM pass.main WHERE user_id = $userId AND resource = $resource;""".query[PassItem].option)
