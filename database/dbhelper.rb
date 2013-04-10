# encoding: utf-8

require "sequel"
require_relative "../parser/entity"
require_relative "../global/settings"


class DbHelper
	Sequel::Model.plugin :schema
  # Sequel::Model.plugin :force_encoding, 'UTF-8'

	def initialize(lang)
    @db = Sequel.sqlite("#{DATABASE_DIR}/test.db")
    @lang = lang
    
    @table_name = :"#{@lang}_pages_cur"
    @db.drop_table? @table_name

    @db.create_table? @table_name do
      primary_key :id, :integer ,:auto_increment
      String :title
      String :redirect

      String :infobox_type
      String :properties
      String :aliases
      String :aliases_forien
      String :categories
      String :sha1
    end

	end
  
  def clean_up
    @db.drop_table? :"#{@lang}_pages"
    @db.rename_table :"#{@lang}_pages_cur", :"#{@lang}_pages"
  end

	def insert_page(page)
    page.string_mode! # make it easy for storage
    
    pages = @db[@table_name]
    
    pages.insert(
    :title          => page.title,
    :redirect       => page.redirect,
      
    :infobox_type   => page.infobox_type,
    :properties     => page.properties,
    :aliases        => page.aliases,
    :aliases_forien => page.aliases_forien,
    :categories     => page.categories,
    :sha1           => page.sha1)

	end
  
  def insert_update_page(page)
    page.string_mode! # make it easy for storage
    
    pages = @db[@table_name]
    
    page_data = pages[:title => page.title]
    # puts page_data
    
    if page_data == nil || page_data.empty?
      # puts "<<<insert"
      pages.insert(
      :title          => page.title,
      :redirect       => page.redirect,
      
      :infobox_type   => page.infobox_type,
      :properties     => page.properties,
      :aliases        => page.aliases,
      :aliases_forien => page.aliases_forien,
      :categories     => page.categories,
      :sha1           => page.sha1)

    else
      # puts "<<<update"
      pages.first(:title => page.title).update(
      :redirect       => page.redirect,
      :infobox_type   => page.infobox_type,
      :properties     => page.properties,
      :aliases        => page.aliases,
      :aliases_forien => page.aliases_forien,
      :categories     => page.categories,
      :sha1           => page.sha1)
    end
  end

	def page_with_title(title, lang)
		# page_data = @pages.where(:title.like('%#{title}%')).first
		# puts title
    pages = @db[:"#{lang}_pages"]
		page_data = pages[:title => title]
		# puts page_data
		# page_data = eval(page_data)
    page = nil
		if page_data
			page = Page.new_page_with_hash_lang(page_data, lang)
		end
		return page
	end
  
  def pages_like_title(title, lang)
    pages = @db[:"#{lang}_pages"]
    title.gsub!(' ', '%')
    similar_pages_data = pages.where(Sequel.ilike(:title, "%#{title}%")).all
    similar_pages = []
    
    similar_pages_data.each do |page_data|
      similar_pages << Page.new_page_with_hash_lang(page_data, lang)
    end
    return similar_pages
  end
end
