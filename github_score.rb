require 'faraday'
require 'faraday_middleware'
require 'pry'
require 'json'

$SCORE = []

class GithubScore
  
  URL = 'https://api.github.com/users/dhh/events/public'
  IssuesEvent, IssueCommentEvent, PushEvent, PullRequestEvent, ReviewCommentEvent, WatchEvent, CreateEvent = 7, 6, 5, 4, 4, 3, 2
  
  # initialize connection
  def initialize
    @connection = Faraday.new(url: URL) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.response :json
    end
  end
  
  #To find the json response from API
  def user_public_commits
    request = @connection.get do |request|
      request.url ''
      request.headers['Content-Type'] = 'application/json'
    end
    response = request.body
    find_github_score(response)
  end

  private

  #To find github score
  def find_github_score(responses)
    responses.each do |response|
      find_score_according_to_type(response["type"])
    end 
    print_the_results   
  end  

  def find_score_according_to_type(type)
     item_score = eval("#{type}").nil? ? 1 : eval("#{type}") 
     $SCORE << [item_score, type]
  end  

  #To print the results
  def print_the_results
    $SCORE = $SCORE.group_by(&:last).map{ |a,b| [b.map(&:first).inject(:+), a] }
    print_total_score
    print_score_for_each_type   
  end  

  def print_total_score
    puts "------------GITHUB SCORE----------"
    puts "DHH's github score is #{$SCORE.map(&:first).sum}"
  end  

  def print_score_for_each_type
    puts "\n\n-----------SCORE FOR EACH TYPE-------"
    $SCORE.each do |task_name|
      puts "SCORE for #{task_name[1]} is #{task_name[0]}"
    end 
  end  
  
end  #end of GithubScore class
