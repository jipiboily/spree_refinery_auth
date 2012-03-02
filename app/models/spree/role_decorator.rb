Spree::Role.class_eval do
	def title
		self.name
	end

	def title= title
		self.name = title
	end

	def camelize_title(role_title = self.title)
      self.title = role_title.to_s.camelize
    end

	def self.[](title)
		find_or_create_by_name(title.to_s.camelize)
	end
end