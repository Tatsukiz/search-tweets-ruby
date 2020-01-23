class TweetsSearch

  require 'json'
	require 'yaml' #Used for configuration files.
	require 'base64' #Needed if managing encrypted passwords.
	require 'fileutils'
	require 'time'

	#Common classes
	require_relative '../common/requester'
	require_relative '../common/queries'
	require_relative '../common/url_maker'
	require_relative '../common/utilities.rb' #Mixin code.
	

	attr_accessor :tweets, #An array of Tweet JSON objects. Can get large. 
	
								:auth, #Bearer-token from YAML file.

								# Search request parameters
								:start_time, :end_time, :since_id, :until_id, :max_results, :format,

								# App configuration details
								:exit_after, :query_file, :write_mode, :out_box

								#Helper objects.
								:requester, #Object that knows RESTful HTTP requests.
								:urlData, #Search uses two different end-points...
								:url_maker, #Object that builds request URLs.

  #Make initial request, and look for 'next' token, and re-request until the 'next' token is no longer provided.
	def get_data(rule, start_time, end_time, since_id, until_id)

		loop do
	
			next_token, result_count = make_data_request(rule, start_time, end_time, since_id, until_id, @max_results, @format, next_token)
			break if next_token.nil? or @requester.request_count >= @exit_after

		end
	
	end #get_data

end #TweetSearch class.
