require "sinatra/base"
require "sinatra/cookies"
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
  helpers Sinatra::Cookies
  
  def initialize
    super
    @langs = {:zh => "Chinese", :en => "English", :ja => "Japanese"}
    @dbhelper = DbHelper.new
  end
  
  get '/' do
    @current_lang = cookies[:current_lang]
    # puts @current_lang
    @current_lang = "zh" unless ["zh", "en", "ja"].include? @current_lang
    redirect to("/#{@current_lang}")
  end
  
  get '/:lang' do
    cookies[:current_lang] = params[:lang]
    @current_lang = params[:lang]
    puts @langs[:"#{@current_lang}"]
    erb :basic
  end

  get '/:lang/w/:title' do
    cookies[:current_lang] = params[:lang]
    @current_lang = params[:lang]
    title = params[:title]
    
    page = @dbhelper.page_with_title(title, @current_lang)
    page.html_property!
    # page.plaintext_property!
    
    @current_lang_pages = []
    @current_lang_pages << LangPage.new(@current_lang, page)
    
    page.aliases_forien.each do |lang, title|
      if title
        forien_page = @dbhelper.page_with_title(title, lang)
        forien_page.plaintext_property! if forien_page
        # puts "-----"
        # puts title if forien_page
        # puts forien_page.class
        @current_lang_pages << LangPage.new(lang, forien_page) if forien_page
      end
    end
    
    # puts @current_lang_pages.count
    
    erb :entity, :layout => :basic
  end

  get '/:lang/s' do
    @current_lang = params[:lang]
    search_text = URI::decode(request.query_string).split('=')[1]
    
    @current_pages = @dbhelper.pages_like_title(search_text, @current_lang)
    erb :search, :layout => :basic
  end
  
  run! if app_file == $0
end

# FrontEnd.run!