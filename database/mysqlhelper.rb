# encoding: utf-8

require "sequel"
require_relative "../parser/entity"
require_relative "../global/settings"


class MySQLHelper
	Sequel::Model.plugin :schema
  # Sequel::Model.plugin :force_encoding, 'UTF-8'

	def initialize
    # @db = Sequel.connect("mysql2://root:@127.0.0.1/wikientity")
    @db = Sequel.connect("mysql2://#{MYSQL_USER}:#{MYSQL_PASSWD}@#{MYSQL_HOST}/#{MYSQL_DATABASE_NAME}")
    LANGS.each do |lang|
      table_name = :"#{lang}_pages"

      @db.create_table? table_name do
        primary_key :id, :integer ,:auto_increment
        String :title
        String :redirect

        String :infobox_type
        TEXT :properties
        TEXT :aliases
        TEXT :aliases_forien
        TEXT :categories
        String :sha1
      end
    end
	end

	def insert_page(page, lang)
    page.string_mode! # make it easy for storage
    
    pages = @db[:"#{lang}_pages"]
    
    begin
      pages.insert(
      :title          => page.title,
      :redirect       => page.redirect,
      
      :infobox_type   => page.infobox_type,
      :properties     => page.properties,
      :aliases        => page.aliases,
      :aliases_forien => page.aliases_forien,
      :categories     => page.categories,
      :sha1           => page.sha1)
    rescue => e
      puts "====ERROR===="
      puts e
      puts page
      puts "============="
    end
	end
  
  def insert_update_page(page, lang)
    page.string_mode! # make it easy for storage
    
    pages = @db[:"#{lang}_pages"]
    
    page_data = pages[:title => page.title]
    # puts page_data
    begin
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
    rescue => e
      puts "====ERROR===="
      puts e
      puts page
      puts "============="
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

if __FILE__ == $0
  mysql_helper = MySQLHelper.new
end

{"company_name"=>"株式會社史克威爾艾尼克斯\nlang ja 株式会社スクウェア・エニックス ", "company_name_en"=>"Square Enix Holdings Co., Ltd.", "company_logo"=>"", "company_type"=>"股份有限公司", "company_slogan"=>"", "market_information"=>"tyo 9684 ", "foundation"=>"1975年9月22日", "location"=>"日本東京都澀谷區代代木三丁目22番7号 新宿文化lang ja クイントビル ", "zip_code"=>"〒151-8544", "telephone_no"=>"+81 3-5333-1555（代表號）", "key_people"=>"和田洋一（代表取締役社長、前史克威爾社長）\n\n本多圭司（代表取締役副社長、前艾尼克斯社長）\n\n福嶋康博（相談役名誉会長、艾尼克斯創業者）", "industry"=>"通訊業", "products"=>"", "capital"=>"78億374万680日圓（2006年3月31日現在）", "revenue"=>"1,244億日圓（2006年3月期、連結）", "operating_income"=>"", "net_income"=>"", "num_employees"=>"3,050人（2006年3月31日現在、連結）", "accounting_period"=>"3月", "parent"=>"", "subsid"=>"SQUARE ENIX, INC.\n\nSQUARE ENIX LTD.\n\nSQUARE ENIX （China） CO., LTD.\n\nEidos Interactive\n\nUIEvolution, Inc.\n\n株式会社TAITO\n\n株式会社SG Lavo\n\nCommunity Engine株式会社\n\n株式会社Digital Entertainment Academy", "homepage"=>"http://www.square-enix.com/", "footnotes"=>"", "width"=>"250px"}
