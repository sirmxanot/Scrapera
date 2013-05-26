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

  @base_url = "http://www.imdb.com"
  @start_url = @base_url + "/name/nm0000102/?ref_=sr_1"
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

  record_actor(actor_name, current_url) 

  record_movies(actor_name, actor_page)
end

def select_actor_name(page)
  page.at_css('h1 text()').text.strip!
end

def record_actor(actor_name, url)
  if @actor_urls.has_key?(actor_name)
  else
    @actor_urls[actor_name] = url 
  end
end

def record_movies(current_actor, page)
  page.css('.filmo-row b a').each do |movie|
    if @movie_edges.has_key?(movie.text)
      @movie_edges[movie.text].push(current_actor)
    else
      @movie_edges[movie.text] = [current_actor]
    end

    if @movie_urls.has_key?(movie.text)
    else
      @movie_urls[movie.text] = @base_url + movie['href']
    end

    if @actor_nodes.has_key?(current_actor)
      @actor_nodes[current_actor].push(movie.text)
    else
      @actor_nodes[current_actor] = [movie.text]
    end
  end
end

def time
  start = Time.now
  movies = bacon
  puts "Completed in #{Time.now - start} seconds."
  puts "results #{titles}"
  #puts "broken links #{errors}"
end