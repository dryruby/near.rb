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
  gem.add_development_dependency 'rspec', '~> 3.12'
  gem.add_development_dependency 'yard' , '~> 0.9'
end
