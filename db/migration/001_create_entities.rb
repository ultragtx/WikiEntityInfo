# encoding: utf-8

require 'sequel'

Sequel.migration do
  change do 
    create_table(:entities) do
      primary_key :id, :integer, :auto_increment
      String :title, null: false
      String :redirect
      String :lang, null: false
    end
  end
end
      