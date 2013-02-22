# encoding: utf-8

require_relative "../parser/wikicloth/lib/wikicloth.rb"


text = <<TEXT
{{URL|1=http://www.sci-corp.com/}}
TEXT

wiki = WikiCloth::Parser.new({
	:data => text,
	:params => { "test" => "World" } })

puts wiki.to_html