#encoding: UTF-8

require 'rmmseg'

RMMSeg::Dictionary.load_dictionaries

puts RMMSeg.constants

text = <<TEXT
董事长 常小兵
TEXT

algor = RMMSeg::Algorithm.new(text)
loop do
    tok = algor.next_token
    break if tok.nil?
    puts "#{tok.text} [#{tok.start}..#{tok.end}]"
end