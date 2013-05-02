#encoding: UTF-8

require 'sequel'

class Property < Sequel::Model
  many_to_one :entity
end