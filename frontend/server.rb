# encoding: utf-8

require "sinatra/base"
require "sinatra/cookies"
require "open-uri"
require "json"
# require_relative '../database/dbhelper'
require_relative '../db/init'
require_relative '../model/init'
require_relative '../combine/combined_entity'

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
    # @dbhelper = DbHelper.new
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
    
    # page = @dbhelper.page_with_title(title, @current_lang)
    
    # @current_lang_pages = []
    # @current_lang_pages << LangPage.new(@current_lang, page)
    
    # page.aliases_forien.each do |lang, title|
    #   if title
    #     forien_page = @dbhelper.page_with_title(title, lang)
    #     # puts "-----"
    #     # puts title if forien_page
    #     # puts forien_page.class
    #     @current_lang_pages << LangPage.new(lang, forien_page) if forien_page
    #   end
    # end
    # 
    # @current_lang_pages.each do |lang_page|
    #   page = lang_page.page
    #   case @current_data_style
    #   when "html"
    #     page.html_property!
    #   when "plain"
    #     page.plaintext_property!
    #   when "raw"
    #     page.properties.each do |key, value|
    #       page.properties[key] = Rack::Utils.escape_html(value)
    #     end
    #     puts page.properties
    #   end
    # end
    
    entity = Entity.where(name: title, lang: @current_lang).first
    @entities = []
    @entities << entity
    
    if entity.en_name
      e = Entity.where(name: entity.en_name, lang: "en").first 
      @entities << e if e
    end
    
    if entity.zh_name
      e = Entity.where(name: entity.zh_name, lang: "zh").first 
      @entities << e if e
    end
    
    if entity.ja_name
      e = Entity.where(name: entity.ja_name, lang: "ja").first 
      @entities << e if e
    end
    
    @entities.each do |e|
      case @current_data_style
      when "html"
        e.html_property!
      when "plain"
        e.plaintext_property!
      when "raw"
        e.escape_html_property!
        # puts page.properties
      end
    end
    
    # puts @entities.count
    
    erb :entity, :layout => :basic
  end
  
  get '/:lang/:data_style/w-comb/:title' do
    cookies[:current_lang] = params[:lang]
    @current_lang = params[:lang]
    
    cookies[:current_data_style] = params[:data_style]
    @current_data_style = params[:data_style]
    
    title = params[:title]
    
    langs = nil
    order = nil
    
    if @current_lang == "zh"
      langs = ["zh", "en", "ja"]
      order = [0, 1, 2]
    elsif @current_lang == "en"
      langs = ["en", "zh", "ja"]
      order = [1, 0, 2]
    elsif @current_lang == "ja"
      langs = ["ja", "en", "zh"]
      order = [2, 1, 0]
    end
    
    if langs && order
      map_path = '/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/combine/company_p_m_t_reduce_complete.txt'
      @combined_entity = CombinedEntity.new(title, langs, map_path, order);
      @combined_entity.combine
      # puts @combined_entity
      
      erb :combinedentity, :layout => :basic
    end
  end

  get '/:lang/:data_style/s' do
    cookies[:current_lang] = params[:lang]
    @current_lang = params[:lang]
    
    cookies[:current_data_style] = params[:data_style]
    @current_data_style = params[:data_style]
    
    # search_text = URI::decode(request.query_string).split('=')[1]
    search_text = params[:search]
    search_text.gsub!('+', '%')
    puts search_text
    # @current_pages = @dbhelper.pages_like_title(search_text, @current_lang)
    @alias_names = AliasName.where(lang: @current_lang).filter(Sequel.ilike(:name, "%#{search_text}%"))
    # puts @alias_names.count
    erb :search, :layout => :basic
  end
  
  #===============================#
  #============ API ==============#
  #===============================#
  
  get '/:lang/:data_style/api/s' do
    puts "api"
    cookies[:current_lang] = params[:lang]
    @current_lang = params[:lang]
    
    cookies[:current_data_style] = params[:data_style]
    @current_data_style = params[:data_style]
    
    # search_text = URI::decode(request.query_string).split('=')[1]
    search_text = params[:search]
    search_text.gsub!('+', '%')
    puts search_text
    # @current_pages = @dbhelper.pages_like_title(search_text, @current_lang)
    @alias_names = AliasName.where(lang: @current_lang).filter(Sequel.ilike(:name, "%#{search_text}%"))
    # puts @alias_names.count
    
    results = []
    @alias_names.each do |alias_name|
      results << {name: alias_name.name,
                  lang: alias_name.lang}
    end
    
    JSON results
  end
  
  get '/:lang/:data_style/w/:title/api' do
    cookies[:current_lang] = params[:lang]
    @current_lang = params[:lang]
    
    cookies[:current_data_style] = params[:data_style]
    @current_data_style = params[:data_style]
    
    title = params[:title]
    
    entity = Entity.where(name: title, lang: @current_lang).first
    
    case @current_data_style
    when "html"
      entity.html_property!
    when "plain"
      entity.plaintext_property!
    when "raw"
      entity.escape_html_property!
      # puts page.properties
    end
    
    entity.to_full_json
  end
  
end

Encoding.default_internal = Encoding::UTF_8

if __FILE__ == $0

  FrontEnd.run!

end
