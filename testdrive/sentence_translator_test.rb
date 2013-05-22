#encoding: UTF-8

require_relative "../translator/sentence_translator"

t = SentenceTranslator.new("zh", "en")
puts t.translate_centence("你看cliff这样能去吗")


t = SentenceTranslator.new("en", "zh")
puts t.translate_centence("Chairman Chang Xiao Bing")


t = SentenceTranslator.new("en", "ja")
puts t.translate_centence("Fixed line and mobile telephony, Internet services, digital television")

t = SentenceTranslator.new("ja", "en")
puts t.translate_centence("中國移动香港(BVI)株式会社 74.21%")

t = SentenceTranslator.new("zh", "ja")
puts t.translate_centence("奚国华公司总经理：李跃")

t = SentenceTranslator.new("ja", "zh")
puts t.translate_centence("情報、通信業")