#encoding: UTF-8

require_relative '../combine/combined_entity'

ce = CombinedEntity.new("中国移動通信", ["ja", "en", "zh"], '/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/combine/company_p_m_t_reduce_complete.txt', [2, 1, 0])
ce.combine
puts ce

#中国移动
#中国移動通信
#China Mobile