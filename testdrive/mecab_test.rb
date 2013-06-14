#encoding: UTF-8

require "mecab/ext"


# Parse japanese text and get extented node instance
nodes = Mecab::Ext::Parser.parse("王建宙(元社長)")
nodes.class #=> Mecab::Ext::Node


# Call Mecab::Ext::Node#each to get each MeCab::Node object
nodes.each {|node| p node.surface }
