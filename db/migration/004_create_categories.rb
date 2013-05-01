# encoding: utf-8

require 'sequel'

Sequel.migration do
  change do 
    create_table(:categories) do
      primary_key :id, :integer, :auto_increment
      String :name, null: false
      String :lang, null: false
      foreign_key :entity_id
    end
  end
end
      
