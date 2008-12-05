# == IMPORTANT!
# This test consumes about 75 query quota of your API key.
# == 중요!
# 이 테스트 파일은 사용자 API Key에 할당된 분량 중, 약 75회 정도의 쿼리 수량을 소모합니다.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'naver'

class TestNaver < Test::Unit::TestCase

	# sets up basic setting for unit testing
	def setup
		# insert your own Naver API key
		@n = Naver::Base.new('your_key')
	end

	# tests if all methods are working fine
	def test_allmethod
		# all methods returning RSS format document
		r = @n.kin("go");	puts r		# This shows you the basic usage clear.
		%w[kin video image doc book book_adv local shop encyc krdic endic jpdic blog cafe cafearticle webkr news].each do |m|
			instance_eval("assert_kind_of(Naver::RSS, r = @n.#{m}('go'))");	puts r
		end

		# all methods returning <result> format XML document
		%w[nexearch cafe blog dic image kin music video webkr site news].each do |q|
			assert_kind_of(Naver::Result, r = @n.rank(q)); puts r			# Select one from "nexearch, cafe, blog, dic, image, kin, music, video, webkr, site, news"
		end
		%w[movie schedulemovie runningmovie people singer foreignsinger talent actor foreignactor entertainer broadcaster comedian sportsstar soccer foreignsoccer drama broadcast game perform book university].each do |q|
			assert_kind_of(Naver::Result, r = @n.ranktheme(q)); puts r		# Select one from "movie, schedulemovie, runningmovie, people, singer, foreignsinger, talent, actor, foreignactor, entertainer, broadcaster, comedian, sportsstar, soccer, foreignsoccer, drama, broadcast, game, perform, book, university"
		end
		%w[recmd adult errata shortcut].each do |m|
			instance_eval("assert_kind_of(Naver::Result, r = @n.#{m}('go'))");	puts r
		end
	end

	# tests is abbreviations for search options are working fine
  def test_abbreviation
		r1 = @n.kin("go", {:display => "5", :start => "6", :sort => "sim"})
		r2 = @n.kin("go", {:d => "5", :st => "6", :so => "sim"})
		assert_equal(5, r1.items.length)		# for checking display
		assert_equal(5, r2.items.length)		# for checking display
		assert_equal(r1.items[0].title, r2.items[0].title)		# for checking start, sort
		puts r1.items.length.to_s + " " + r2.items.length.to_s
		puts r1.items[0].title + " " + r2.items[0].title

		r1 = @n.video("go", {:filter => "high", :payment => "charge"})
		r2 = @n.video("go", {:f => "high", :p => "charge"})
		assert_equal(r1.items.length, r2.items.length)		# for checking filter, payment
		puts r1.items.length.to_s + " " + r2.items.length.to_s
  end

	# tests if all output fields looks fine
	def test_alloutput
		@a_kin = %w[title link description]
		@a_video = %w[thumbnail]
		@a_image = %w[sizeheight sizewidth]
		@a_book = %w[image author price discount publisher pubdate isbn]
		@a_local = %w[telephone address mapx mapy]
		@a_shop = %w[lprice hprice]
		@a_blog = %w[bloggername bloggerlink]
		@a_cafe = %w[ranking member totalarticles newarticles]
		@a_cafearticle = %w[cafename cafeurl]
		@a_news = %w[originallink pubDate]

		r, rr = @n.kin("go"), nil
		%w[lastBuildDate total start display].each do |f|
			instance_eval("assert_kind_of(String, rr = r.#{f})");	puts rr
		end

		%w[kin video image book local shop blog cafe cafearticle news].each do |s|
			instance_eval("r = @n.#{s}('go')")
			self.instance_variable_get("@a_#{s}").each do |f|
				instance_eval("assert_kind_of(String, rr = r.items[0].#{f})");	puts rr
			end
		end

		r = @n.rank("nexearch")
		assert_kind_of(String, rr = r.ranks[0].K); puts rr
		assert_kind_of(String, rr = r.ranks[0].S); puts rr
		assert_kind_of(String, rr = r.ranks[0].V); puts rr

		r = @n.ranktheme("movie")
		assert_kind_of(String, rr = r.ranks[0].K); puts rr
		assert_kind_of(String, rr = r.ranks[0].S); puts rr
		assert_kind_of(String, rr = r.ranks[0].V); puts rr

		r = @n.recmd("spdlqj")
		assert_kind_of(String, rr = r.recmds[0]);	puts rr

		r = @n.adult("go")
		assert_kind_of(String, rr = r.adult);	puts rr

		r = @n.errata("go")
		assert_kind_of(String, rr = r.errata);	puts rr

		r = @n.shortcut("naver")
		assert_kind_of(String, rr = r.shortcuts[0].label);	puts rr
		assert_kind_of(String, rr = r.shortcuts[0].url);	puts rr

	end

end
