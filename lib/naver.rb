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

%w[cgi net/http libxml].each {|lib| require lib}

$:.unshift(File.join(File.dirname(__FILE__)))

require "naver/base"
require "naver/rss"
require "naver/result"
require "naver/item"

module Naver
  include LibXML

	class NoMethod < StandardError; end
	class NoQuery < StandardError; end

	# Searches that returns results in RSS format
	RSS_LIST = %w[kin video image doc book book_adv local shop encyc krdic endic jpdic blog cafe cafearticle webkr news]

	# Searches that returns results in Non-RSS but XML format
	XML_LIST = %w[rank ranktheme recmd adult errata shortcut]

	# Whole available search list
	METHOD_LIST = RSS_LIST.concat(XML_LIST)

	# Abbreviation for passing options
	ABBREVIATION = {:d => :display, :st => :start, :so => :sort, :f => :filter, :p => :payment,
									:dt => :d_titl, :da => :d_auth, :dco => :d_cont, :di => :d_isbn, :dp => :d_publ,
									:ddaf => :d_dafr, :ddat => :d_dato, :dca => :d_catg}
end