#encoding: UTF-8

require 'youdao-fanyi'

YoudaoFanyi::Config.key_from = "longtimenoc"
YoudaoFanyi::Config.key = 284983591

sentence = "全俺が泣いた…！この涙腺崩壊動画がスゴイ"

puts YoudaoFanyi.search_json(sentence)