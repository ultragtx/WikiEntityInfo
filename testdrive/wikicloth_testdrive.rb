# encoding: utf-8

require_relative "../parser/wikicloth/lib/wikicloth.rb"


text = <<TEXT
{{CNY|link=yes|527.99 billion}} (2011)<ref name="icbc-ltd.com">http://www.google.com/finance?q=NYSE%3ACHL&fstype=ii&ei=_r1rUOjpCcabkAX3Cg</ref>  
TEXT

wiki = WikiCloth::Parser.new({
	:data => text,
	:params => { "test" => "World" } })

puts wiki.to_html