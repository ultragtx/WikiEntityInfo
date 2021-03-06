# encoding: utf-8

require 'sequel'

Sequel.migration do
  change do 
    create_table(:properties) do
      primary_key :id, :integer, :auto_increment
      String :key, null: false
      Text :value
      String :lang, null: false
      foreign_key :entity_id
    end
  end
end
      
