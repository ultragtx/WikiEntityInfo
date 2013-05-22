#encoding: UTF-8

require 'bing_translator'

translator = BingTranslator.new("wikientityinfo", "HxD+q3eLEWjGaqoVJDWNUlUXZWJX/L9YW0toR148xS8")
spanish = translator.translate 'Hello. This will be translated!', :from => 'en', :to => 'es'
puts spanish