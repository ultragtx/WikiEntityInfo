#encoding: UTF-8

require_relative '../translator/bing_translator_cached'

translator = BingTranslatorCached.new("wikientityinfo", "HxD+q3eLEWjGaqoVJDWNUlUXZWJX/L9YW0toR148xS8")
# spanish = translator.translate 'Hello. This will be translated!', :from => 'en', :to => 'es'
# puts spanish

# jp = translator.translate '早上好', :to => 'ja'
# puts jp


ch = translator.translate '全俺が泣いた…！この涙腺崩壊動画がスゴイ', :to => 'zh-CN'

puts ch
