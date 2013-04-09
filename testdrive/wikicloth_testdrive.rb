# encoding: utf-8

# puts RUBY_VERSION
# puts Encoding.default_external
# puts Encoding.default_internal

require_relative "../parser/wikicloth/lib/wikicloth.rb"
require 'nokogiri'

text = <<TEXT
{{CNY|link=yes|527.99 billion}} (2011)<ref name="icbc-ltd.com">http://www.google.com/finance?q=NYSE%3ACHL&fstype=ii&ei=_r1rUOjpCcabkAX3Cg</ref> 
TEXT

text = <<TEXT
{{CNY|link=yes|527.99 billion}} (2011)<ref name="icbc-ltd.com">http://www.google.com/finance?q=NYSE%3ACHL&fstype=ii&ei=_r1rUOjpCcabkAX3Cg</ref>
TEXT

text = <<TEXT
<!-- OPTIONAL : State school colours, using words, then <br>then
                                         {{colorbox|#xxyyzz}}
TEXT

# text.gsub!(/(\{\{(.*?)\}\})/m) do |template|
#   content = $2
#   content.gsub!('|',' ')
#   content.gsub!('=', ':')
#   content + " "
# end
# 
# puts text

# text = <<TEXT
# [[China Mobile Communications Corporation]] (74.22%) [http://www.chinamobileltd.com/images/pdf/2010/ar/2009_a_full.pdf Annual report 2009]
# TEXT

# text = <<TEXT
# [[File:Shijo Karasuma FT Square.JPG||280px]]
# TEXT



class TestCloth < WikiCloth::Parser
  
  # template do |template|
  #   puts '>>>>>template'
  #   puts template
  #   puts '<<<<<template'
  # end
  
  # include_resource do |resource,options|
#     puts '>>>>>include_resource'
#     puts "resource #{resource}"
#     options.each do |opt|
#       puts "name:#{opt[:name]}, value:#{opt[:value]}"
#     end
#     puts '<<<<<include_resource'
#     ""
#   end
  
  
end

wiki = WikiCloth::Parser.new({
	:data => text,
	:params => { "test" => "World" } })

puts wiki.to_html

__END__

wiki = WikiCloth::Parser.new({
	:data => text,
	:params => { "test" => "World" } })

puts wiki.to_html

# puts Nokogiri::HTML('<img alt="asdf" src="asdf">').text()

# puts WikiCloth::Parser.localise_ns("File",:ja)