#encoding: UTF-8

require 'sequel'

class AliasName < Sequel::Model
  many_to_one :entity
end