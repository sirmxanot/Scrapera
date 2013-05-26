# This is a web crawler that obtains the data from IMDB necessary 
# to write a shortest path algorithm that finds the minimum path between
# any actor and kevin bacon.
#actors are nodes, movies are edges, kevin bacon is the source node

#TODO: limit movie selection so that it only selects movies not other types of
# actor endevors. Then add selection of the related URLs. Probably need xpath
def bacon
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

  @base_url = "http://www.imdb.com/"
  @start_url = @base_url + "name/nm0000102/?ref_=sr_1"
  current_url =  @start_url

  # actor_nodes: actor name is key, value is an array of all movie_edges
  @actor_nodes = Hash.new
  # movie_edges: movie name is key, value is an array of all actor_nodes
  @movie_edges = Hash.new
  # actor_urls: the key is an actor's name and the value is the imdb url
  @actor_urls = Hash.new
  # movie_urls: the key is a movie name and the value is the imdb url
  @movie_urls = Hash.new

  load_graph(current_url)
end

def load_graph(current_url)
  actor_page = Nokogiri::HTML(open(current_url))
  @actor_page = Nokogiri::HTML(open(current_url))

  actor_name = select_actor_name(actor_page)

  puts "actor name is #{actor_name}"

  record_actor(actor_name, current_url) 

  actors_movies = select_movies(actor_page)

  puts "actor's movies #{actors_movies}"
end

def select_actor_name(page)
  page.at_css('h1 text()').text.strip!
end

def record_actor(actor_name, url)
  if @actor_nodes.has_key?(actor_name)
  else
    @actor_nodes[actor_name] = []
  end

  if @actor_urls.has_key?(actor_name)
  else
    @actor_urls[actor_name] = url 
  end
end

def select_movies(page)
  movies = []

  @actor_page.css('.filmo-row b a text()').each do |movie|
    movies.push(movie.text)
  end

  movies
end


def time
  start = Time.now
  movies = bacon
  puts "Completed in #{Time.now - start} seconds."
  puts "results #{titles}"
  #puts "broken links #{errors}"
end