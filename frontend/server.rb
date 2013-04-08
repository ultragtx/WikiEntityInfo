# encoding: utf-8

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
    @data_styles = {:raw => "Raw", :html => "HTML", :plain => "Plain"}
    @dbhelper = DbHelper.new
  end
  
  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end
  
  get '/' do
    @current_lang = cookies[:current_lang]
    @current_lang = "zh" unless ["zh", "en", "ja"].include? @current_lang
    
    @current_data_style = cookies[:current_data_style]
    @current_data_style = "html" unless ["html", "raw", "plain"].include? @current_data_style
    
    redirect to("/#{@current_lang}/#{@current_data_style}")
  end
  
  get '/:lang/:data_style' do
    cookies[:current_lang] = params[:lang]
    @current_lang = params[:lang]
    
    cookies[:current_data_style] = params[:data_style]
    @current_data_style = params[:data_style]
    
    # puts @langs[:"#{@current_lang}"]
    erb :basic
  end

  get '/:lang/:data_style/w/:title' do
    cookies[:current_lang] = params[:lang]
    @current_lang = params[:lang]
    
    cookies[:current_data_style] = params[:data_style]
    @current_data_style = params[:data_style]
    
    title = params[:title]
    
    page = @dbhelper.page_with_title(title, @current_lang)
    
    @current_lang_pages = []
    @current_lang_pages << LangPage.new(@current_lang, page)
    
    page.aliases_forien.each do |lang, title|
      if title
        forien_page = @dbhelper.page_with_title(title, lang)
        # puts "-----"
        # puts title if forien_page
        # puts forien_page.class
        @current_lang_pages << LangPage.new(lang, forien_page) if forien_page
      end
    end
    
    @current_lang_pages.each do |lang_page|
      page = lang_page.page
      case @current_data_style
      when "html"
        page.html_property!
      when "plain"
        page.plaintext_property!
      when "raw"
        page.properties.each do |key, value|
          page.properties[key] = Rack::Utils.escape_html(value)
        end
        puts page.properties
      end
    end
    
    # puts @current_lang_pages.count
    
    erb :entity, :layout => :basic
  end

  get '/:lang/:data_style/s' do
    cookies[:current_lang] = params[:lang]
    @current_lang = params[:lang]
    
    cookies[:current_data_style] = params[:data_style]
    @current_data_style = params[:data_style]
    
    # search_text = URI::decode(request.query_string).split('=')[1]
    search_text = params[:search]
    search_text.gsub!('+', ' ')
    puts search_text
    @current_pages = @dbhelper.pages_like_title(search_text, @current_lang)
    erb :search, :layout => :basic
  end
  
  run! if app_file == $0
end

Encoding.default_internal = Encoding::UTF_8

if __FILE__ == $0

  FrontEnd.run!

end
