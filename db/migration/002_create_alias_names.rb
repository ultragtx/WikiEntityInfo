# encoding: utf-8

require 'sequel'

Sequel.migration do
  change do 
    create_table(:alias_names) do
      primary_key :id, :integer, :auto_increment
      String :name
      String :lang, null: false
      foreign_key :entity_id
    end
  end
end
      
