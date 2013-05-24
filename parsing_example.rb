require 'rubygems'
require 'nokogiri'
require 'open-uri'

def go
  origin = "http://en.wikipedia.org"
  titles = []
  #page = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/Special:Random"))
  link = "http://en.wikipedia.org/wiki/Special:Random"
  
  until titles.count == 10 do 
    page = Nokogiri::HTML(open(link))
    titles.push page.css('h1')[0].text
    link = origin + page.css('p a')[0]['href']
    sleep 1
  end
  
  puts titles
end