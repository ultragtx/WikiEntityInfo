require "sequel"
require_relative "../global/settings"


class DbHelper
	Sequel::Model.plugin :schema
  
  def initialize
    @db = Sequel.sqlite("#{DATABASE_DIR}/sequel_test.db")
  end
  
  def create
    @db.create_table? "test_table" do
      primary_key :id, :integer ,:auto_increment
    end
  end
  
  def drop
    @db.drop_table? "test_table"
  end
  
end



dbhelper = DbHelper.new

dbhelper.create
gets

dbhelper.drop