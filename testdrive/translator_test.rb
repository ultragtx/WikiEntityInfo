#encoding: UTF-8

require_relative "../translator/translator"

# t = CustomTranslator.translator_with_lang("C2E")
# 
# puts t.dictionary["中国"].translations[0]
# 
# t = CustomTranslator.translator_with_lang("C2E")
# 
# puts t.dictionary["中国"].translations[0]
# 
# puts t.translate("长", "zh")
# puts t.translate("小", "zh")
# puts t.translate("兵", "zh")

# t = CustomTranslator.translator_with_lang("E2J")
# puts t.translate("computer", "en")
t = CustomTranslator.translator_with_lang("J2E")
puts t.translate("株式会社", "ja")
# t = CustomTranslator.translator_with_lang("C2J")
# puts t.translate("计算 ", "zh")
# t = CustomTranslator.translator_with_lang("J2C")
# puts t.translate("ドル", "ja")