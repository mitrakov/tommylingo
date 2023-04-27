package com.mitrakoff.self.tommylingo

case class DictKey(userId: Int, langCode: String, key: String)

case class Dict(dictKey: DictKey, translation: String)

case class AllKeys(keys: List[String])

case class KeyValues(kv: List[(String, String)])
