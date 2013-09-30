def scrape(username)
  require 'rubygems'
  require 'bundler/setup'
  require 'nokogiri'
  require 'open-uri'

  @BASE_URL          = 'https://github.com/login'

  agent = Mechanize.new
  user_page = agent.get(@AUTH_URL + "/#{username}")
  signin_form = signin_page.forms.first
  puts signin_form.fields
end