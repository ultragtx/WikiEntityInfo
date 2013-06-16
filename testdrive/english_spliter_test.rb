#encoding: UTF-8

require_relative "../translator/sentence_translator"


spliter = EngSpliter.new('Fixed line and mobile telephony, Internet services, digital television')
puts spliter.words