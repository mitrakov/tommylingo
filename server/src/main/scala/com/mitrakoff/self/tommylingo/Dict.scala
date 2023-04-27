package com.mitrakoff.self.tommylingo

case class DictKey(userId: Int, langCode: String, key: String)

case class Dict(dictKey: DictKey, translation: String)
