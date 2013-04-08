require "/Users/ultragtx/DevProjects/Ruby/WikiParser/OpenSourceParser/kiwi/ffi/yapwtp.rb"

parser = WikiParser.new

wikitext = parser.html_from_string "== first heading =="

puts wikitext