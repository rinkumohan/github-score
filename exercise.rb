require_relative "github_score"

#Program begins here
begin
  GithubScore.new.user_public_commits
rescue => e
  puts "Something went wrong!"
end