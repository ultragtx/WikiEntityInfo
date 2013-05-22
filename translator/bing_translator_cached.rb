#encoding: UTF-8

require_relative 'bing_translator'

class BingTranslatorCached < BingTranslator
  CACHE_FILE_PATH = '/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/translator/bing_translate'
  
  
  def initialize(client_id, client_secret, skip_ssl_verify = false)
    super
    @cached_translations = {}
  end

  def parse_cache_file(to_lang)
    file = File.open("#{CACHE_FILE_PATH}_#{to_lang}.txt", "a+")
    file.seek(0, IO::SEEK_SET)
    content = file.read
    file.close
    
    current_translations = {}
    
    content.scan(/^### (.*?) \$\$\$$/m) do |line|
      line = line[0]
      comps = line.split(' <<==>> ')
      if comps.count == 2
        key = comps[0]
        value = comps[1]
        current_translations[key] = value
      end
    end
    # puts current_translations
    @cached_translations[to_lang] = current_translations
  end
  
  def append_cache_file(to_lang, key, value)
    file = File.open("#{CACHE_FILE_PATH}_#{to_lang}.txt", "a")
    file << "### #{key} <<==>> #{value} $$$\n"
    file.flush
    file.close
  end
  
  
  def translate(text, params = {})
    raise "Must provide :to." if params[:to].nil?
    
    parse_cache_file(params[:to])
    
    result = nil
    cache = @cached_translations[params[:to]]
    if cache
      result = cache[text]
    end
    
    unless result
      begin
        result = super
        cache[text] = result
        append_cache_file(params[:to], text, result)
      rescue => e
        result = nil
      end
    end
    
    result
  end
  
end