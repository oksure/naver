require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('naver', '0.3.1') do |p|
	p.description		= "Ruby Gem for Naver OpenAPI"
	p.url			= "http://oksurerails.com/naver"
	p.author		= "Hyunwoo Park"
	p.email			= "hwpark@oksurerails.com"
	p.ignore_pattern	= ["tmp/*", "script/*"]
	p.development_dependencies = ["libxml-ruby >=0.9.2"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

