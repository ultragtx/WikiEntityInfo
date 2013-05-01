# encoding: utf-8

require 'sequel'

Sequel.migration do
  change do 
    create_table(:entities) do
      primary_key :id, :integer, :auto_increment
      String :name, null: false
      String :redirect
      String :infobox_type
      String :lang, null: false
      String :en_name
      String :zh_name
      String :ja_name
    end
  end
end
      