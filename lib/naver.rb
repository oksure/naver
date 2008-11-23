# = Naver
#   An easy interface to the Naver OpenAPI (http://dev.naver.com/openapi/tutorial). By Hyunwoo Park.
#
# Author::    Hyunwoo Park <hwpark@oksurerails.com>
# Copyright:: Copyright (c) 2008 Hyunwoo Park <hwpark@oksurerails.com>
# License::   MIT <http://www.opensource.org/licenses/mit-license.php>
#
# USAGE:
#  require 'naver'
#  naver = Naver.new(api_key)		### create a naver client
#  naver.request("kin", "go", {:display => "5", :start => "1", :sort => "sim"})		### return root node as libxml node


require "cgi"
require "net/http"
require "xml"

class Naver

	# Replace this API key with your own (see http://dev.naver.com/openapi/register)
	def initialize(key=nil)
		@key = key
		@host = 'http://openapi.naver.com'
		@api = '/search'
	end

  # Takes a Naver API method name and set of parameters; returns an libxml object with the response
  def request(target, query, params={})
    response = http_get(request_url(target, query, params))
		parser = XML::Parser.new
		parser.string = response
	  doc = parser.parse
		doc.root
  end

  # Takes a Naver API method name and set of parameters; returns the correct URL for the REST API.
  def request_url(target, query, params={})
    url = "#{@host}#{@api}?key=#{@key}&target=#{target}&query=#{query}"
		params.each { |key, value| url += "&#{key}=" + CGI::escape(value) } unless params.nil?
    url
  end

  # Does an HTTP GET on a given URL and returns the response body
  def http_get(url)
    Net::HTTP.get_response(URI.parse(url)).body.to_s
  end

end