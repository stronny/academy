#!/syntax/ruby
require File.expand_path('../lib/academy/version.rb', __FILE__)
Gem::Specification.new do |s|
	s.files = [
		'lib/academy.rb',
		'lib/academy/version.rb',
		'lib/academy/ui.rb',
		'lib/academy/wizard.rb',
		'lib/academy/step.rb',
		'LICENSE',
		'README.md',
	]
	s.name = 'academy'
	s.summary = 'teminal wizards assembly line'
	s.description = open(File.expand_path('../README.md', __FILE__)) { |fd| fd.read.match(/\[\/\/\]: # \(DESCRIPTION START\)(.*)\[\/\/\]: # \(DESCRIPTION STOP\)/m)[1].strip }
	s.version = Academy::VERSION
	s.has_rdoc = false
	s.license = 'CC0'
	s.required_ruby_version = '>= 2.0.0'
	s.author = 'stronny red'
	s.email = 'stronny@celestia.ru'
	s.homepage = 'https://github.com/stronny/academy'
end
