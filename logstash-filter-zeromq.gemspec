Gem::Specification.new do |s|

  s.name            = 'logstash-filter-zeromq'
  s.version         = '0.1.0'
  s.licenses        = ['Apache License (2.0)']
  s.summary         = "ZeroMQ filter. This is a way to send an event externally for filtering"
  s.description     = "ZeroMQ filter. This is a way to send an event externally for filtering. It works much like an exec filter would by sending the event 'offsite' for processing and waiting for a response"
  s.authors         = ["Elasticsearch"]
  s.email           = 'richard.pijnenburg@elasticsearch.com'
  s.homepage        = "http://logstash.net/"
  s.require_paths = ["lib"]

  # Files
  s.files = `git ls-files`.split($\)+::Dir.glob('vendor/*')

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency 'logstash', '>= 1.4.0', '< 2.0.0'

  s.add_runtime_dependency 'ffi-rzmq', ['1.0.0']

end

