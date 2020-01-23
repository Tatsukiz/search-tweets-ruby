=begin
Helper function for building URLs. Developed for Labs usage.
=end

class URLMaker

	LABS_VERSION = 1 #Versioning.

	attr_accessor :url, :search_tier, :search_period

	def initialize
		@data_url = "https://api.twitter.com/labs/#{LABS_VERSION}/tweets/search" #Versioning.
		@search_tier = 'labs'
		@search_period = 'recent'
	end

	def getDataURL()
		@data_url
	end
	
	def getCountURL()

		return "Counts endpoint not supported in Labs."
		
	end

end
