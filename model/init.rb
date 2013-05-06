#encoding: UTF-8

Sequel::Model.plugin :json_serializer

require_relative 'entity'
require_relative 'alias_name'
require_relative 'property'
require_relative 'category'