def scrape(username)
  require 'rubygems'
  require 'bundler/setup'
  require 'nokogiri'
  require 'open-uri'

  @BASE_URL          = 'https://github.com/login'

  user_page = Nokogiri::HTML(open(@AUTH_URL + "/#{username}"))
 
  elements = user_page.at_css('.avatared h1').text
end