Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = "near"
  gem.homepage           = "https://github.com/dryruby/near.rb"
  gem.license            = "Unlicense"
  gem.summary            = "NEAR.rb: NEAR for Ruby"
  gem.description        = "A Ruby client library for the NEAR Protocol."
  gem.metadata           = {
    'bug_tracker_uri'   => "https://github.com/dryruby/near.rb/issues",
    'changelog_uri'     => "https://github.com/dryruby/near.rb/blob/master/CHANGES.md",
    'documentation_uri' => "https://rubydoc.info/gems/near",
    'homepage_uri'      => gem.homepage,
    'source_code_uri'   => "https://github.com/dryruby/near.rb",
  }

  gem.author             = "Arto Bendiken"
  gem.email              = "arto@bendiken.net"

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CHANGES.md README.md UNLICENSE VERSION) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w()

  gem.required_ruby_version = '>= 3.0'
  gem.add_runtime_dependency 'base64' # Ruby 3.4.0+
  gem.add_runtime_dependency 'bigdecimal' # Ruby 3.4.0+
  gem.add_runtime_dependency 'faraday', '>= 2.12'
  gem.add_runtime_dependency 'faraday-follow_redirects', '>= 0.3'
  gem.add_runtime_dependency 'faraday-retry', '>= 2.0'
  #gem.add_runtime_dependency 'json'
  #gem.add_runtime_dependency 'open3'
  gem.add_development_dependency 'rspec', '~> 3.13'
  gem.add_development_dependency 'yard' , '~> 0.9'
end
