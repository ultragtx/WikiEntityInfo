#encoding: UTF-8

require 'youdao-fanyi'

YoudaoFanyi::Config.key_from = "longtimenoc"
YoudaoFanyi::Config.key = 284983591

sentence = "这是一句中文"

puts YoudaoFanyi.search_json(sentence)