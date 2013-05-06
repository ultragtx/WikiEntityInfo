#encoding: UTF-8


require_relative '../db/init'
require_relative '../model/init'
# require 'json'

e = Entity[3]
puts e.name
e.alias_names.each do |alias_name|
  puts alias_name.name
end

e.properties.each do |property|
  puts property.key + "=" + property.value
end
  
  
puts e.to_full_json




