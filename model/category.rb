#encoding: UTF-8

require 'sequel'

class Category < Sequel::Model
  many_to_one :entity
end