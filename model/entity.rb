#encoding: UTF-8

require 'sequel'

class Entity < Sequel::Model
  one_to_many :alias_names
end