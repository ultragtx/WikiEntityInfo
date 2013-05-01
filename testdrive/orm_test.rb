#encoding: UTF-8

require 'sequel'


DB = Sequel.connect(adapter: 'sqlite', database: "/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/db/wikiinfo.db")
puts DB
# puts DB.methods.sort
puts DB.tables

require_relative '../model/entity'
require_relative '../model/alias_name'
require_relative '../model/property'

entity = Entity.new
entity.name = "test"
entity.lang = "en"

alias_name = AliasName.new
# puts AliasName.columns

# puts alias_name.methods.sort
alias_name.name = "test"
alias_name.lang = "en"
alias_name.save
# 
property = Property.new
property.key = "testkey"
property.value = "testvalue"
property.lang = "en"
property.save

entity.save
entity.add_alias_name(alias_name)
entity.add_property(property)

e = Entity[3]
puts e.name
e.alias_names.each do |alias_name|
  puts alias_name.name
end

e.properties.each do |property|
  puts property.key + "=" + property.value
end
  
  
e.name = "what the fuck"





