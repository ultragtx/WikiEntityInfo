# encoding: UTF-8

require_relative "../parser/entity"
require_relative '../parser/info_parser'

text = <<TEXT
{{Use dmy dates|date=May 2011}}
{{Use Australian English|date=May 2011}}
{{Refimprove|date=May 2010}}
{{Primary sources|date=May 2010}}

<!-- Fill in the below, providing as much detail as you can. If a field is marked "Optional", then 
     you can leave it to be filled in later.
     This is the minimum for a good page, so please try to fill in as much as you can.
     There are (many) other parts to this template which can be used also. View the whole template
     at "http://en.wikipedia.org/wiki/Template:Infobox_school". -->

{{Infobox school
|name                   = Al Amanah College
|image                  = Liverpool Al Amanah College.JPG
|alt                    = <!-- OPTIONAL : IF image PROVIDED; Provide a short caption for the
|caption                = 
                                          image -->
|motto                  = 'Success Through Knowledge'<!-- OPTIONAL : Provide the school's motto, if from a different language
                                          use (replacing ?? with the language code):
                                          {{lang-??|TEXT GOES HERE}} -->
|motto_translation      = <!-- OPTIONAL : Provide a translation of the above Motto -->
|city                   = [[Bankstown, New South Wales|Bankstown]] & [[Liverpool, New South Wales|Liverpool]]
|state                  = [[New South Wales]]
|country                = [[Australia]]
|coordinates            = {{Coord|33|54|59.67|S|151|1|41.50|E|type:edu}} <br />Bankstown
{{Coord|33|55|49.42|S|150|55|14.17|E|type:edu}}<br />Liverpool
|schooltype             = [[Private School|Private]]
|religious_affiliation  = Islamic
|established            = <!-- OPTIONAL : State the year in which the school was established -->
|principal              = Mohamad El Dana
|viceprincipal          = N. Mehio (Bankstown)<br />Wissam Saad (Liverpool)
|viceprincipal_label    = Deputy Principals
|asst principal         = <!-- OPTIONAL : (If one assistant principal) State the name of the
                                          Assistant Principal of the school NOTE: Do not use
                                          title, ie, Mr., Mrs., etc. -->
|assistant_principals   = <!-- OPTIONAL : (If more than one assistant principal) State the names
                                          of the Assistant Principals of the school NOTE: Do not
                                          use title, ie, Mr., Mrs., etc. -->
|teaching_staff         = <!-- OPTIONAL : State the number of staff -->
|grades                 = <!-- MANDATORY: Usually K-2, K-6, K-7, 7-12 or 11-12 -->
|enrolment              = <!-- OPTIONAL : State approximate number of students, (using a tilde
                                          to represent an approximate number, ie, ~999) and
                                          reference  with <ref> -->
|campus type            = <!-- OPTIONAL : Indicate if the school is [[Urban]], [[Suburban]] or
                                         [[Rural]] -->
|colours                = <!-- OPTIONAL : State school colours, using words, then <br>then
                                         {{colorbox|#xxyyzz}}
|website                = <!-- MANDATORY: Provide the school's website address -->
}}

'''Al-Amanah College''' is an [[Islamic]] [[private school]]. It has two campuses in [[Bankstown, New South Wales|Bankstown]] and [[Liverpool, New South Wales|Liverpool]]. Al Amanah College is a project developed by the Islamic Charity Projects Association. The school motto is 'Success Through Knowledge'.

Al Amanah College commenced its first year of its [[primary School]] on 2 February 1998. The Bankstown campus features a primary school, playground and [[mosque]]. The Liverpool campus features a primary school, [[high school]] and playgrounds. The Liverpool campus has over 600 students in both primary and secondary.

The school employs more than 50 staff members. The Principal of both campuses is Mohamad El Dana and the deputies are N. Mehio (Bankstown campus) and W. Saad (Liverpool Campus). The High School Coordinator A Alwan and his assistant L. Daboussi coordinate the operations at Liverpool.

On 29 April 2010, it was reported that the [[Australian Christian Churches]]-run [[Alphacrucis]] Bible College had sold their Chester Hill campus for $23 million to Mohammed Mehio, an associate of Al Amanah.<ref>[http://www.dailytelegraph.com.au/news/nsw-act/rejected-islamic-college-is-reborn/story-e6freuzi-1225859636654 Kamper, Angela. "Rejected Islamic college is reborn: An Islamic group whose plans for a school were rejected amid controversy last year has bought a new 7ha site just 7km away. ''[[The Daily Telegraph (Australia)]]'' 29 April 2010]</ref>

==References==
<references/>

== External links ==
* [http://www.alamanah.nsw.edu.au Official website]
{{City of Bankstown topics}}

[[Category:Educational institutions established in 1998]]
[[Category:High schools in New South Wales]]
[[Category:Islamic schools in Australia]]
[[Category:Private schools in New South Wales]]
[[Category:1998 establishments in Australia]]
TEXT

page = Page.new
page.title = "test"
page.aliases = []
page.aliases_forien = {}
page.categories = []
parser = InfoParser.new("en")
useful_type, infobox_type, infobox_properties = parser.get_infobox(text)
page.properties = infobox_properties
puts page
puts page.plaintext_property!