Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: "http://#{ENV['ELASTICSEARCH_USER']}:#{ENV['ELASTICSEARCH_PASSWORD']}@#{ENV['ELASTICSEARCH_HOST']}:#{ENV['ELASTICSEARCH_PORT']}"
  # client = Elasticsearch::Client.new(url: 'https://username:password@localhost:9200')
)
