package com.mitrakoff.self.tommylingo

class RootService[F[_]](dao: Dao[F]) {
  def getAllKeys(userId: Int, langCode: String): F[List[String]] = dao.fetchAllKeys(userId, langCode)

  def getTranslations(userId: Int, langCode: String): F[List[(String, String)]] = dao.fetchWithLimit(userId, langCode, 25)

  def upsert(dict: Dict): F[Int] = dao.persist(dict)

  def remove(dictKey: DictKey): F[Int] = dao.delete(dictKey)
}
