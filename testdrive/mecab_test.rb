#encoding: UTF-8

require "mecab/ext"


# Parse japanese text and get extented node instance
nodes = Mecab::Ext::Parser.parse("北京市西城区金融街29号")
nodes.class #=> Mecab::Ext::Node


# Call Mecab::Ext::Node#each to get each MeCab::Node object
nodes.each {|node| p node.surface }
