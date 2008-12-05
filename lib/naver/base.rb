module Naver

	# fundamental class for naver gem
	class Base

		# attributes for accessing retrieved raw xml and parsed libxml root node
		attr_accessor :doc_root, :raw_xml

		# Replace this API key with your own (see http://dev.naver.com/openapi/register)
		def initialize(key=nil)
			@key = key
			@host = 'http://openapi.naver.com'
			@api = '/search'
		end

		def method_missing(target, query, params={})
			raise NoQuery if query.empty?
			if METHOD_LIST.include?(target.to_s)
				request(target, query, params)
				if XML_LIST.include?(target.to_s)
					return Result.new(@doc_root, target.to_s)
				else
					return RSS.new(@doc_root)
				end
			else
				raise NoMethod
			end
		end

		# Takes a Naver API method name and set of parameters; returns an libxml object with the response
		def request(target, query, params={})
			response = http_get(request_url(target, query, params))
			parser, parser.string = LibXML::XML::Parser.new, response
			@raw_xml = parser.parse
			@doc_root = @raw_xml.root
		end

		# Takes a Naver API method name and set of parameters; returns the correct URL for the REST API.
		def request_url(target, query, params={})
			url = "#{@host}#{@api}?key=#{@key}&target=#{target}&query=#{query}"
			params.each do |key, value|
				key = ABBREVIATION[key] unless ABBREVIATION[key].nil?
				url += "&#{key}=" + CGI::escape(value)
			end unless params.nil?
			url
		end

		# Does an HTTP GET on a given URL and returns the response body
		def http_get(url)
			Net::HTTP.get_response(URI.parse(url)).body.to_s
		end

	end
end
