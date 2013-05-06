#encoding: UTF-8
require 'sequel'
require 'yaml'

config = YAML.load_file "./config/config.yaml"

adapter = config["database"]["adapter"]
database = config["database"]["database"]
user     = config["database"]["user"]
host     = config["database"]["host"]
passwd   = config["database"]["passwd"]

if adapter == "mysql2"
  sequel_database = "#{adapter}://#{user}:#{passwd}@#{host}/#{database}"
else                
  sequel_database = "sqlite:///Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/db/#{database}.db"
end
puts sequel_database

puts "Init DB"

Sequel.connect(sequel_database)

