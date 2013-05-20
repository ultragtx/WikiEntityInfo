#encoding: UTF-8

require_relative "../translator/translator"

t = CustomTranslator.translator_with_lang("C2E")

puts t.dictionary["中国"].translations[0]

t = CustomTranslator.translator_with_lang("C2E")

puts t.dictionary["中国"].translations[0]

puts t.translate("长", "zhe")
puts t.translate("小", "zhe")
puts t.translate("兵", "zhe")