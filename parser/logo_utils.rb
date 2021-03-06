# encoding: utf-8

require 'digest/md5'
require 'open-uri'

class LogoUtils
  
  def self.link_for_logo(name, lang)
    filename = name.gsub(" ", "_")
    encoded_filename = URI::encode(filename)
    digest = Digest::MD5.hexdigest(filename)
    file_url = "http://upload.wikimedia.org/wikipedia/#{lang}/#{digest[0]}/#{digest[0]}#{digest[1]}/#{encoded_filename}"
  end

end


# puts LogoUtils.link_for_logo("China Mobile Logo.svg", "en")