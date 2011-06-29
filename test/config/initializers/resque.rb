url = ENV["REDISTOGO_URL"]

if url
  uri = URI.parse(url)
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end