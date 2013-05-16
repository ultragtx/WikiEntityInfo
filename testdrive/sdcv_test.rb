#encoding: UTF-8

require 'dickens'
require_relative "../global/settings"

Dickens::StarDict.executable = SDCV_PATH

# puts  Dickens::StarDict.list

list=Dickens::StarDict.list
items = Dickens::StarDict.where("Dick", [list[1], list[3]])

items.each do |item|
  puts "[1]"
  puts item.article
  puts "[2]"
  puts item.dictionary
  puts "[3]"
  puts item.word
  puts "[4]"
  puts item.matching
end

