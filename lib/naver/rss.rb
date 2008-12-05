module Naver
	
	# contains RSS type return and converts XML format to Ruby format
  class RSS
		
		# variable for accessing items
		attr_accessor :items

		# creates RSS class object from libxml node input
    def initialize(doc_root)
      channel = doc_root.find("//rss/channel").first
			%w[lastBuildDate total start display].each do |f|
				RSS.class_eval("attr_accessor :#{f}")
				self.instance_variable_set("@#{f}", channel.find(f).first.content)
			end

			@items = []
			channel.find("item").each do |i|
				@items << Item.new(i)
			end
    end
  end
end
