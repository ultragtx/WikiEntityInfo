# encoding: utf-8

require_relative "../parser/wikicloth/lib/wikicloth.rb"
require 'nokogiri'

text = <<TEXT
{{CNY|link=yes|527.99 billion}} (2011)<ref name="icbc-ltd.com">http://www.google.com/finance?q=NYSE%3ACHL&fstype=ii&ei=_r1rUOjpCcabkAX3Cg</ref>  
TEXT

text = <<TEXT
[[File:Shijo Karasuma FT Square.JPG||280px]]
TEXT


wiki = WikiCloth::Parser.new({
	:data => text,
	:params => { "test" => "World" } })

puts wiki.to_html

# puts Nokogiri::HTML('<img alt="asdf" src="asdf">').text()

# puts WikiCloth::Parser.localise_ns("File",:ja)