require "sinatra"
require "open-uri"
require_relative '../Database/dbhelper'

class LangPage
  attr_accessor :lang
  attr_accessor :page
  
  def initialize(lang, page)
    self.lang = lang
    self.page = page
  end
end

class FrontEnd < Sinatra::Application
  
  
  def initialize
    super
    @langs = {:zh => "Chinese", :en => "English", :ja => "Japanese"}
    @dbhelper = DbHelper.new
  end
  
  get '/' do
    redirect to('/zh')
  end
  
  get '/:lang' do
    @current_lang = params[:lang]
    puts @langs[:"#{@current_lang}"]
    erb :basic
  end

  get '/:lang/w/:title' do
    @current_lang = params[:lang]
    title = params[:title]
    
    page = @dbhelper.page_with_title(title, @current_lang)
    page.full_mode!
    
    @current_lang_pages = []
    @current_lang_pages << LangPage.new(@current_lang, page)
    
    page.aliases_forien.each do |lang, title|
      if title
        forien_page = @dbhelper.page_with_title(title, lang)
        forien_page.full_mode! if forien_page
        puts "-----"
        puts title if forien_page
        puts forien_page.class
        @current_lang_pages << LangPage.new(lang, forien_page) if forien_page
      end
    end
    
    puts @current_lang_pages.count
    
    erb :entity, :layout => :basic
  end

  get '/:lang/s' do
    @current_lang = params[:lang]
    search_text = URI::decode(request.query_string).split('=')[1]
    
    @current_pages = @dbhelper.pages_like_title(search_text, @current_lang)
    erb :search, :layout => :basic
  end
  

  get '/o' do
    # puts request.query_string
    # puts URI::decode(request.query_string)
    # 
    #   text = URI::decode(request.query_string).split('=')[1]
    # 
    #   CURRENT_PAGE = DBHELPER.page_with_title(text) if text
    #   CURRENT_PAGE.properties = eval(CURRENT_PAGE.properties.to_s)
    #   CURRENT_PAGE.aliases = eval(CURRENT_PAGE.aliases.to_s)
    #   CURRENT_PAGE.aliases_forien = eval(CURRENT_PAGE.aliases_forien.to_s)

    # puts CURRENT_PAGE.title
    # puts CURRENT_PAGE.infobox_type
    # puts CURRENT_PAGE.properties
    # puts CURRENT_PAGE.aliases
    # puts CURRENT_PAGE.aliases_forien
    # 
    erb :index


    # if CURRENT_PAGE.title
    # 	CURRENT_PAGE.infobox_type

    # 	CURRENT_PAGE.aliases.each do |aliase_name |
    # 		aliase_name
    # 	end

    # 	CURRENT_PAGE.properties.each do |key, value|
    # 		key
    # 		value
    # 	end

    # 	CURRENT_PAGE.aliases_forien do |key, value|
    # 		key
    # 		value
    # 	end

    # else

    # end
  end
  
  run! if app_file == $0
end

# FrontEnd.run!