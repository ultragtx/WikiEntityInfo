#encoding: UTF-8

require_relative '../combine/combined_entity'

ce = CombinedEntity.new("中国移动", ["zh", "en", "ja"], '/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/combine/company_p_m_t_reduce_complete.txt')
ce.combine
puts ce