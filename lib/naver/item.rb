module Naver

	# contains each item's information and converts XML format to Ruby format
  class Item

		# creates Item class object from libxml node input
    def initialize(doc)
			if cs = doc.children
				cs.each do |c|
					Item.class_eval("attr_accessor :#{c.name}")
					self.instance_variable_set("@#{c.name}", c.content)
				end
			end
    end
  end
end
