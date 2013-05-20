#encoding: UTF-8

require_relative "../translator/sentence_translator"

t = SentenceTranslator.new("zh", "en")
puts t.translate_centence("晚上给你爆料")

