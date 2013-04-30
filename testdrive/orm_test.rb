#encoding: UTF-8

require 'sequel'


DB = Sequel.connect(adapter: 'sqlite', database: "/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/db/wikiinfo.db")
puts DB
# puts DB.methods.sort
puts DB.tables

require_relative '../model/entity'
require_relative '../model/alias_name'

alias_name = AliasName.new
# puts AliasName.columns

# puts alias_name.methods.sort
alias_name.name = "test"
alias_name.lang = "en"
alias_name.save
# 
entity = Entity.new
entity.title = "test"
entity.lang = "en"
entity.save

