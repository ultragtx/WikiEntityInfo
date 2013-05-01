#encoding: UTF-8
require 'sequel'

puts "Init DB"

Sequel.connect(adapter: 'sqlite', database: "/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/db/wikiinfo.db")