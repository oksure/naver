module Naver
	
	# contains Result type return and converts XML format to Ruby format
  class Result
		
		# variable for accessing items
		attr_accessor :items

		# creates Result object from libxml node input
    def initialize(doc_root, target)
      channel = doc_root.find("//result").first

			case target
			when "rank", "ranktheme":
				Result.class_eval("attr_accessor :ranks")
				@ranks = []
				channel.find("item").first.children.each do |c|
					@ranks << Item.new(c)
				end
			when "recmd":
				Result.class_eval("attr_accessor :recmds")
				@recmds = []
				channel.find("item").each do |i|
					@recmds << i.content
				end
			when "adult", "errata":
				Result.class_eval("attr_accessor :#{target}")
				self.instance_variable_set("@#{target}", channel.find("item/#{target}").first.content)
			when "shortcut":
				Result.class_eval("attr_accessor :shortcuts")
				@shortcuts = []
				channel.find("item/shortcut").each do |s|
					@shortcuts << Item.new(s)
				end
			else
				Result.class_eval("attr_accessor :items")
				@items = []
				channel.find("item").each do |i|
					@items << Item.new(i)
				end
			end
    end
  end
end
