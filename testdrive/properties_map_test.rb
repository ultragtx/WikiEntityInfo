#encoding: UTF-8

require_relative '../combine/properties_map'

p = PropertiesMap.new('/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/combine/company_p_m_t_reduce_complete.txt', [1, 0, 2])

map = p.properties_map
puts p