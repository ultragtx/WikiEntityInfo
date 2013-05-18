#encoding: UTF-8

require_relative '../db/init'
require_relative '../model/init'
require_relative 'info_parser'
require_relative 'entity'

class SinglePageInjector < InfoParser
  
  def inject_page(name, lang, text)
    useful_type, infobox_type, infobox_properties = get_infobox(text)
    
    entity = Entity.new
    entity.name = name
    entity.lang = lang
      
    aliases = get_alias(text)
    categories = get_category(text)
    aliases_forien = get_forien_alias(text)
    
    # set infobox type
    entity.infobox_type = infobox_type
    
    # set forien names
    entity.en_name = aliases_forien[:en]
    entity.zh_name = aliases_forien[:zh]
    entity.ja_name = aliases_forien[:ja]
    
    entity.save # save to get id
    
    # set alias_names
    aliases << entity.name # add current name to aliases
    aliases.uniq!
    
    aliases.each do |name|
      alias_name = AliasName.new
      alias_name.name = name
      alias_name.lang = @lang
      entity.add_alias_name(alias_name)
      alias_name.save
    end
    
    # set properties
    infobox_properties.each do |key, value|
      property = Property.new
      property.key = key
      property.value = value
      property.lang = @lang
      entity.add_property(property)
      property.save
    end
    
    # set categories
    categories.each do |name|
      category = Category.new
      category.name = name
      category.lang = @lang
      entity.add_category(category)
      category.save
    end
  end
end

if __FILE__ == $0
  lang = "zh"
  name = "中国移动"
  
  text = <<TEXT
{{Infobox_Company
|company_name_zh =中国移动有限公司
|company_name =中国移动有限公司
|company_logo = [[File:Chinamobile.png|175px]]
|company_type = [[上市公司]]
|market_information ={{sehk|0941}}<br />{{nyse|CHL}}
|company_slogan = 沟通从心开始；移动信息专家；正德厚生 臻于至善
|foundation = [[1997年]][[9月3日]]|
|location = {{CHN}}[[北京市]][[西城区]][[金融街 (北京)|金融街]]29号
|industry = [[電訊]]
|key_people =[[奚国华]]公司[[总经理]]：[[李跃]]
|sales = 电信网络运营、電信增值服務
|profit = {{increase}}1293億元人民幣(2012年)
|asset = 5634.93億元人民幣(2007年){{CNY|952.55 billion}} (2011)
|market_value = 約15595億港元(2008年12月31日)
|num_employees = 145954人(截止2009年末)181,000 (2012)
|products =
|revenue = {{increase}}5604億元人民幣(2012年)
|homepage = {{url|10086.cn}}<br>{{url|chinamobileltd.com}}
}}
[[File:China_Mobile.JPG|thumb|right|200px|中国移动通信]]
[[File:ChinaMobileEmergencyCar.JPG|thumb|right|200px|中国移动[[广州]]分公司应急信号发射车]]
[[File:HK Great Eagle Centre 2007.jpg|thumb|right|200px|[[香港]][[鷹君中心]]基座上的中國移動英文China Mobile廣告標誌牌（藍底白字）]]

'''中国移动有限公司'''（简称“'''中国移动通信'''”或“'''中国移动'''”）是2000年4月20日成立的[[中国]]国有重要骨干企业，注册资本为518亿元[[人民币]]，截至2008年9月30日，资产规模超过8,000亿元[[人民币]]。

中国移动通信拥有全球第一的[[流動電話|移动通信]]网络规模和客户规模，连续多年入选《[[财富 (杂志)|财富]]》杂志世界500强企业，2010年排名为第77位，是[[2008年夏季奧林匹克運動會|北京2008年奥运会]]合作伙伴和[[2010年上海世博会]]全球合作伙伴。旗下的'''中國移動有限公司'''為上市公司（{{sehk|0941}}，{{nyse|CHL}}），前稱'''中國電訊'''（并不是“[[中國電信]]”）， <ref> {{cite web|url=http://www.chinamobile.com/aboutus/intro/ |title=集团介绍_中国移动通信 |accessdate=2007-12-11 |publisher=中国移动通信 |language=zh-cn }}</ref>

根據[[福布斯]]的資料顯示，中國移動有限公司是在香港注冊的公司中市值最高的一間。<ref> {{cite web|url=http://www.forbes.com/lists/2006/18/06f2000_The-Forbes-2000_MktVal.html |title=The Forbes 2000 |accessdate=2007-12-11 |date=2006-3-30 |publisher=Forbes.com Inc. |language=en }}</ref>
2006年8月10日，中国移动在[[纽约]]股市[[市值]]达到1325.8亿美元，成为目前全球市值最大的电信运营商。
<ref>{{cite news | first= | last= | coauthors= | title=中国移动通信业二十年大事记 | date=2007-11-22 | publisher=新浪网 | url =http://tech.sina.com.cn/t/2007-11-22/15291868347.shtml | work =光明网-光明日报 | pages = | accessdate = 2007-12-11 | language = zh-cn }}</ref>2008年5月23日，中国移动通信集团公司通报，[[中国铁通]]集团有限公司并入中国移动通信集团公司，成为其全资子企业。随着中国移动对中国铁通的兼併[[重组]]，[[2008年中國電訊業重組|中国通信業界史上最大规模的重新整合]]也随之展开。在中国移动对中国铁通的资产核查完成之前，中国铁通仍将保持相对独立运营。<ref>{{cite web| url=http://news.xinhuanet.com/fortune/2008-05/23/content_8234708.htm| title=电信业重组拉开帷幕 中国铁通并入中国移动| work = 新华网 | pages = | accessdate = 2008-05-23 | language = zh-cn}}</ref>

中国移动通信集团公司全资拥有[[中国移动（香港）集团有限公司]]，由其控股的[[中国移动有限公司]]在[[中国]]境内的31个[[省]]、[[直辖市]]、[[自治区]]设立全资子[[公司]]，並在[[香港]]和[[纽约]]上市。目前，中国移动有限公司是中国在境外上市公司中市值最大的公司之一。

在中国境内，中国移动通信集团公司主要经营移动语音、[[数据]]、[[IP电话]]和[[多媒体]]业务，并具有[[互联网]]国际联网单位经营权和国际出入口局业务经营权。除提供基本话音业务以外，还提供[[传真]]、数据[[IP电话]]等增值业务，拥有“[[全球通]]”、“[[动感地带]]”、“[[神州行]]”、“G3”等品牌。

== 历史 ==
* [[1949年]][[11月1日]]，中华人民共和国[[邮电部]]成立。
* [[1987年]][[11月18日]]，中国内地第一个[[模拟移动电话通信网]]在[[广东省]][[广州市]]开通。
* [[1993年]][[9月19日]]，中国内地第一个[[数字移动电话通信网]]在[[浙江省]][[嘉兴市]]开通。
* 1994年3月26日，邮电部下设移动通信局和数据通信局。
* [[1994年]]10月，中国内地第一个省级数字移动通信网在[[广东省]]开通。
* 1997年9月3日，以[[广东]]移动通信有限责任公司和[[浙江]]移动通信有限责任公司为基础成立中国电信（香港）有限公司，注册地为[[香港]]。
* 1997年10月22日和23日，中国电信（香港）有限公司在[[美国]][[纽约证券交易所]]和[[香港联合交易所]]上市。
* 1998年1月27日，中国电信（香港）有限公司[[股票]]成为[[香港恒生指数]][[恒生指數#恒生指數成份股|成份股]]。
* 1998年6月4日，中国电信（香港）有限公司正式完成对[[江苏]]移动通信有限责任公司的[[收购]]。
* 1999年11月12日，中国电信（香港）有限公司正式完成对[[福建]]、[[河南]]、[[海南]]等三省移动通信网络资产的[[收购]]。
* 2000年4月20日，中国移动通信集团公司成立，中国电信（香港）有限公司为其全资拥有的子公司。
* 2000年6月28日，中国电信（香港）有限公司更名为中国移动（香港）有限公司。<ref> {{cite web|url=http://www.chinatelecom.com.cn/corp/01/02/index.html#2000 |title=中国电信大事年表 |accessdate=2007-12-11 |publisher=中国电信集团公司 |language=zh-cn }}</ref>
* 2000年11月13日，中国移动（香港）有限公司正式完成对[[北京]]、[[上海]]、[[天津]]、[[河北]]、[[辽宁]]、[[山东]]、[[广西]]等七[[省]]（[[自治区]]、[[直辖市]]）移动通信网络资产的[[收购]]。
* 2002年7月1日，中国移动（香港）有限公司正式完成对[[安徽]]、[[江西]]、[[重庆]]、[[四川]]、[[湖北]]、[[湖南]]、[[陕西]]、[[山西]]等八省（直辖市）移动通信网络资产的收购。
* 2004年7月1日，中国移动（香港）有限公司正式完成对[[内蒙古]]、[[吉林]]、[[黑龙江]]、[[贵州]]、[[云南]]、[[西藏]]、[[甘肃]]、[[青海]]、[[宁夏]]、[[新疆]]等十[[省]]（[[自治区]]、[[直辖市]]）移动通信网络资产的收购，以及对中国移动通信有限公司、京移通信设计院有限公司的全额收购，从而成为第一家在中国内地所有三十一[[省]]（[[自治区]]、[[直辖市]]）经营电信业务的海外上市中国电信企业。
* 2004年11月1日，[[中国电信]]、中国移动和[[中国联通]]三大基础[[电信运营商]]高层变动，原[[中国联通]]总裁[[王建宙]]出任中国移动集团公司[[总裁]]。<ref>{{cite news | first= | last= | coauthors= | title=中国移动总经理王建宙：欲领十万兵 世界争一流 | date=2006-08-18 | publisher=北方网 | url =http://economy.enorth.com.cn/system/2006/08/18/001387778.shtml | work =市场报 | pages = | accessdate = 2007-12-11 | language = zh-cn }}</ref>
* 2005年11月10日，中国移动（香港）有限公司宣布全额收购香港移动电讯商[[PEOPLES]]（[[华润万众电话有限公司]]），该项收购及该公司的[[私有化]]于2006年3月28日正式完成，该公司後改名为[[中国移动万众电话有限公司]]，为中国移动（香港）有限公司全资拥有的子公司。
* 2006年5月29日，经香港公司注册处批准，中国移动上市公司名称由“中国移动(香港)有限公司改为“中国移动有限公司。。<ref> {{cite web|url=http://www.chinamobileltd.com/about.php?menu=6 |title=公司大事记 |accessdate=2007-12-11 |publisher=中国移动有限公司 |language=zh-cn }}</ref>
* 2007年1月22日，中国移动通信集团公司宣布收购米雷康姆（[[Millicom]]）公司控股的巴基斯坦巴科泰尔（[[Paktel]]）公司，并于2007年5月16日正式完成对该公司的全额收购，<ref> {{cite web|url=http://www.ltcinternational.com/press-clippings/2007_05.php |title=May 2007 Archived Press Clippings : LTC International, Telecom Headlines and Industry News |accessdate=2007-12-11 |publisher=LTC International Inc. |language=en }}</ref>该公司于2007年5月4日改名为[[CMPak有限公司]]（中文名称“[[辛姆巴科公司]]”）。<ref> {{cite web|url=http://scholar.ilib.cn/A-txqygl200706021.html |title=中国移动巴基斯坦公司正式更名为CMPak |accessdate=2007-12-11 |language=zh-cn }}</ref>
* 2008年4月1日，中国移动面向北京、上海、天津、沈阳、广州、深圳、厦门和秦皇岛8个城市，正式启动TD-SCDMA社会化业务测试和试商用。
* 2008年5月23日，中国移动通信集团公司发布通报，[[中國鐵通集團有限公司]]并入中国移动通信集团公司，成为其全资[[子公司]]。<ref>{{cite web|url=http://hk.news.yahoo.com/080523/12/2ui85.html |title=中移動併中國鐵通 |accessdate=2008-05-23 |publisher=雅虎香港 |language=zh-tw }}</ref>
* 2009年1月7日，中国工业和信息化部正式向中国移动通信集团公司颁发基于[[TD-SCDMA]]规格的第三代移动通信（[[3G]]）营业执照。
* 2009年4月30日，將以每股40元新台幣認購遠傳私募新股4.44億股入股台灣[[遠傳電信]]，持股比例12%。斥資177.7億元新台幣。
* 2010年3月10日中国移动全資附屬公司[[廣東移動]]已於[[浦發銀行]]簽訂股份認購協議，以每股18.03元人民幣，398億元人民幣（約452.55億港元）現金，認購浦發行發行約22.1億股A股新股。交易完成後，中國移動將通過全資附屬公司廣東移動持有浦發銀行 20%股權，並成為浦發銀行第二大股東
* 2010年5月31日，李跃接任集团总经理，王建宙改任集团董事长、党组书记。<ref>{{cite web|url=http://tech.sina.com.cn/t/2010-05-31/15584250635.shtml |title=中移动最高层变动 李跃接任总经理|accessdate=2010-5-31|language-zh-cn}}</ref>
* 2010年7月14日，中国移动门户网站自2010年7月15日起正式启用10086.cn作为新域名，原chinamobile.com域名仍然有效。 
* 2011年2月22日，与[[新华通讯社]]合作推出“盘古搜索”，定位是“国家级搜索引擎”，这是继“人民搜索”後第二个由中共官方媒体控制的搜索引擎。
* 2011年8月24日 中国移动與深圳上市的安徽科大讯飞信息科技股份有限公司簽訂了股份認購協議及戰略合作協議，當中以13.63億元人民幣認購科大訊飛約15%權益7027.39萬股每股發行價19.4元股份有三年禁售期。根據戰略合作協議，雙方將在智能語音、智能語音雲服務、智能語音技術和創新產品等方面建立戰略合作。
* 2012年9月7日在香港成立中國移動通信集團金融投資有限公司:公司註冊處1797630

=== Vodafone入股 ===
* 2000年[[Vodafone]]斥資25億美元購入2.5%權益，成為策略股東，每股平均作價48元。
* 2002年7月斥資7.5億美元增持，每股平均作價 24.72元。
* 2010年[[9月8日]] Vodafone以每股79.2港元，出售持有3.2%或6.42億股[[中國移動]]股份，股權套現517億元。

== 经营业务 ==
中国移动通信的业务范围包括基于[[GSM]]／[[GPRS]]、[[TD-SCDMA]]、[[WCDMA/DC-HSPA+]]规格的移动电话业务以及其旗下子公司[[中国铁通]]经营的固定电话和有线宽带业务。在中国大陆地区由中国移动通信提供服务的移动电话号码以134(0-8)、135、136、137、138、139、150、151、152、157、158、159、182、183、187、188开头<ref>{{cite news | first= | last= | coauthors= | title=移动150号段暂不在北京放号 | date=2007-09-11 | publisher=中国网 | url =http://www.china.com.cn/economic/txt/2007-09/11/content_8855191.htm | work =新京报 | pages = | accessdate = 2007-12-11 | language = zh-cn }}</ref>，TD-SCDMA数据卡接入开始启用147号段<ref>{{cite news | first= | last= | coauthors= | title=工信部首次颁发14开头手机子号段独家给TD | date=2009-02-05 | publisher=环球网 | url =http://tech.huanqiu.com/net/comm/2009-02/363140.html | work = | pages = | accessdate = 2009-02-05 | language = zh-cn }}</ref>。

=== 经营业务范围 ===
目前中国移动的经营范围包括：
* [[中国大陆]]
* [[香港]]
* [[巴基斯坦]]

== 各品牌口号 ==
* 公司口号：“沟通从心开始”，“移动信息专家”，“正德厚生 臻于至善”
* 全球通：“我能！”
* 动感地带：“我的地盘听我的！”“我的地盘，3G生活听我的！”
* 神州行：“轻松由我，神州行！”，“神州行，我看行！”
* G3：“G3，引领3G生活”
* 动力100：“释放信息的力量。”

== 重大事件 ==
=== 模拟手机用户退网事件 ===
2001年3月5日，[[中华人民共和国信息产业部]]发布《关于中国移动通信集团公司停止使用模拟移动通信业务频率的通知》（信部无[2001]152号），宣布在2001年6月30日后无条件收回模拟移动通信业务所占频段，在2001年12月31日后将把该频段用于数字移动通信业务，并要求中国移动在2001年12月31日停止模拟移动通信业务。<ref> {{cite web|url=http://vip.chinalawinfo.com/Case/displaycontent.asp?gid=117489329 |title=林鸿仿诉海南移动通信有限责任公司电信转网案 |accessdate=2007-12-11 |first=李晓莉 |publisher=北大法律信息网 |language=zh-cn }}</ref>

从1993年起，中国大陆的移动公司就同时经营着模拟A网（[[TACS]]制式，[[摩托罗拉]]设备）、模拟B网（TACS制式，[[爱立信]]设备）、数字G网（[[GSM]]制式）三种制式的网络，其中前两种被业界认为是第一代移动通信技术，而GSM为第二代。中国移动通信集团公司成立后全盘接受了这一现实，并开始逐步引导模拟用户转用GSM网络。到信息产业部发文时，中国大陆数字手机用户已达8000多万，模拟用户则从1994年时的600多万回落到约250万，模拟网的利用率低下（频率占15%，用户占3%，业务量占0.09%）。<ref>{{cite news | first=李红军 | last= | coauthors= | title=(社会新闻) 模拟移动 光荣退休 | date=2001-12-15 | publisher=中国邮电新闻工作者协会 | url =http://ydjx.cnii.com.cn/20020201/ca17257.htm | work =大河报 | pages = | accessdate = 2007-12-11 | language = zh-cn }}</ref>

根据信息产业部的该文件，中国移动通信集团公司通告全国用户，通过给予一定补偿的方式，展开了模拟转数字工作，并于2001年12月31日宣布关闭了模拟移动电话网<ref> {{cite web|url=http://www.chinamobile.com/aboutus/intro/200702/t20070215_3505.htm |title=2001年大事记_中国移动通信 |accessdate=2007-12-11 |publisher=中国移动通信 |language=zh-cn }}</ref>。

由于中国大陆在模拟网前期向用户收取多达3万元的初装费，一些用户发起诉讼要求中国移动通信集团公司给予高额赔偿，已知判决中均败诉。

因希冀高额赔偿或使用率低下等多种原因，2002年时仍有未完成转网的原模拟用户。

=== 村村通电话工程 ===
2004年起，中国移动通信集团公司投资实施“村村通电话工程”。目前该[[工程]]尚在实施中。

* 该工程实施前：
** 截至2003年底，中国内地尚有7万多个[[行政村]]（占总数的10.77%）未通[[电话]]，90%以上在中国大陆中西部经济落后省份。

* 工程实施后：
** [[湖南省]]于2006年实现了全部4659个[[行政村]]100%通[[电话]]的目标，该[[工程]]被评为[[湖南省]]2005年度十大[[公益]]事件之“最具时代感的公益事件”；
** [[四川省]]实现了对[[甘孜]]、[[阿坝]]、[[凉山]]这三个平均[[海拔]]3000米以上的[[州]]的48[[县]]、680[[乡镇]]、5000多个[[村]]的覆盖；
** [[云南省]]于2004年9月为中国唯一的[[独龙族]]（总人口5816人）聚居地解决了对外联系问题，自此中国55个[[少数民族]]聚居区全部开通了[[移动电话]]；
** [[山西省]]4087个[[行政村]]结束了不通[[电话]]的历史，新覆盖[[农村]]人口数达200万；
** [[宁夏回族自治区]]于2005年为被[[联合国]]认定为“最不适合人类居住”的[[国家级贫困县]][[西吉县]]开通了[[GSM]]移动通信服务；
** [[青海省]]于2005年12月20日实现了所有[[乡镇]]、83%的[[行政村]]的[[GSM]]网络覆盖。
* 根据[[中华人民共和国]][[信息产业部]]的统计，截至2006年9月30日，该工程已为29773个村开通了[[电话]]，将[[行政村]]通话比例提高了4.3个百分点，受益地区中包括了[[四川]][[甘孜]]、[[阿坝]]、[[凉山]]以及[[青海]][[玉树藏族自治州|玉树]]、[[果洛]]等基础设施条件极差、甚至没有通电、通路的偏远农村地区。<ref> {{cite web|url=http://www.chinamobile.com/cr/P040201.html |title=村村通电话工程 |accessdate=2007-12-11 |work=中国移动通信集团公司企业责任报告 |publisher=中国移动通信集团公司 |language=zh-cn }}</ref>

=== 短信内容审查事件 ===
2010年，为配合中国公安部门开展“手机违法短信息治理”，中国移动通信宣布对其用户实施短信内容审查，并声称用户发送“黄色信息”将可能被强制停止该用户的短信服务。此举引起较大的争论，南方报业网登载文章指出此举违宪<ref>{{cite news|language=zh-cn|publisher=南方报业网|title=中国移动“过滤”黄色短信涉嫌违宪|url=http://nf.nfdaily.cn/spqy/content/2010-01/20/content_8333275.htm|date=2010-01-20|accessdate=2010-02-05}}</ref>。

=== “亂收費”情況 ===
2010年7月5日， [[中央電視台]]《[[新闻1+1]]》節目播出「移动通信，不是移动『收费』！」節目， 節目中指出一些地方移动公司在用户不知情的情况下重复计费、错误计费，并且随意添加或删除计费数据。<ref>{{cite news|language=zh-cn|publisher=中国网络电视台|title=新闻1+1 移动通信，不是移动“收费”！|url=http://news.cntv.cn/china/20100705/103716.shtml|date=2010-07-05|accessdate=2010-07-07}}</ref>

== 中国大陆网络封锁 ==
据报，中国移动（不含香港）在[[防火长城]]的基础上，额外封锁中国移动认为的不良网站累计超60万个，其中由中国大陆接入的[[成人网站]]占1.2%，境外接入的网站占98.8%，互联网网站占大多数，WAP网站的比例不足5%。这表示，在使用中国移动无线网络及中国铁通有线宽带时将会有更多的港澳台及海外网站无法访问，而已在当局备案的大陆同志网站<ref>{{cite news|url=http://www.danlan.org/disparticle_42547.htm |title= 中国移动被指在部分地区屏蔽同志网站 |date=2013-01-11 |publisher= 新华网 |accessdate=2012-10-23}}</ref>及大量相关的基于[[地理位置服務|地理位置]]提供的[[社交網路服務]]软件同样被视作“不良”而封锁<ref>{{cite news|url=http://e.weibo.com/2626499125/zdWdqh9Ht |title= 中国移动封锁同志交友软件|date=2013-01-09 |publisher= Blued交友软件新浪微博官方账号}}</ref>，但是在其它ISP的网络下则正常。<ref>{{cite news|url=http://www.nx.xinhuanet.com/2012-08/02/c_112603779.htm |title= 中国移动封堵手机不良网站累计超60万个|date=2012-08-02 |publisher= 新华网 |accessdate=2012-10-23}}</ref>

在中国移动以及中国铁通的网络上，被封锁的知名网站包括：[[维基媒体基金会]]文件及图片服务器（upload.wikimedia.org）、[[Flickr]]、[[Amazon.com]]图片服务器、[[Wikia]]、[[Google]]的文件及图片服务器（.ggpht.com/*.googleusercontent.com，图片搜索及诸多Google服务不能使用或出错）等，其中部分支持[[Https]]的网站能以该方式访问。此外，[[HTC]]手机（含外国/港/台行货）天气预报服务器（[[:en:AccuWeather|AccuWeather]]提供） htc.accuweather.com同样被封锁，而使用中国联通和中国电信的网络则可以正常访问。

== 参考文献 ==
{{Reflist|2}}

== 外部链接 ==
{{Commonscat|China Mobile}}
* [http://www.10086.cn 中国移动通信集团公司]
* [http://www.hk.chinamobile.com 中國移動香港]
* [http://www.zong.com.pk ZONG]（中国移动在[[巴基斯坦]]的分公司）

== 参见 ==
* [[中华人民共和国境内地区移动终端通讯号码]]
* [[工业和信息化部]]、[[国务院国资委]]
* [[中国联通]]、[[中国电信]]

{{-}}
{{中国移动通信公司}}
{{Hang Seng Index Constituent Stocks}}
{{Hang Seng China-Affiliated Corporations Index‎}}
{{Hang Seng China 50 Index}}
{{信息技术大公司}} 

[[Category:香港交易所上市牛熊證]]
[[Category:中国移动]]
[[Category:中国通信公司]]
[[Category:香港上市電訊業公司]]
[[Category:恆生指數成份股]]
[[Category:恆生港中企業指數成份股]]
[[Category:香港交易所上市認股證]]
[[Category:1997年成立的公司]]
TEXT
  
  spi = SinglePageInjector.new(lang)
  spi.inject_page(name, lang, text);
  
end
    