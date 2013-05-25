#this is my first webcrawler. it starts on a random wikipedia page and then 
# follows the first link within the body of the article until it has visited 
# ten pages. then it returns the titles of the ten pages. 

# TODO: 1)Fix error handling for links. 2) Add error handling for titles
# 3) Improve selectors. 4) figure out why method chaining not working
require 'rubygems'
require 'nokogiri'
require 'open-uri'

def wiki(iterations = 10)
  @titles = []
  @broken_links = []
  @origin = "http://en.wikipedia.org"
  link = @origin + "/wiki/Special:Random"
  @links = [link]
  
  until @titles.count == iterations do 
    page = Nokogiri::HTML(open(@links.last))

    #page.select_title.record_title
    record_title(select_title(page))

    #page.select_link.record_link
    record_link(select_link(page))

    sleep 1
  end
  
  return @titles, @broken_links
end

public 

def select_title(page)
  title = page.at_css('h1').text
  puts "title is #{title}"
  title
end

def record_title(title)
  @titles.push title
end

def select_link(page, link_number = 0)
  link = @origin + page.css('p a')[link_number]['href']

  puts "next_link is #{link}"

  if check_link(page, link) != link
    puts "error"
    select_link(page, link_number += 1)
  end

  link
end

def check_link(prev_page, link)
  begin
    page = Nokogiri::HTML(open(link))
  rescue
    @broken_links.push(link)
  else
    link
  end
end

def record_link(link)
  @links.push link
end

def time
  start = Time.now
  titles, errors = wiki
  puts "Completed in #{Time.now - start} seconds."
  puts "results #{titles}"
  puts "broken links #{errors}"
end