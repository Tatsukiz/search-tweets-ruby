# A general object that knows how to make HTTP requests.
# A simple, common RESTful HTTP class put together for Twitter RESTful endpoints.
# Does authentication via header, so supports BEARER TOKEN authentication.

#=======================================================================================================================

class Requester
	require "net/https" 
	require "uri"

	attr_accessor :url,
								:uri,
								:data,
								:headers, #i.e. Authentication specified here.
								:bearer_token,
								:request_count,
								:request_limit

	def initialize(url=nil, bearer_token=nil, headers=nil)

		if not url.nil?
			@url = url
		end

		if not headers.nil?
			@headers = headers
		end

		if not bearer_token.nil?
			@bearer_token = bearer_token
		end

		@request_count = 0
		@request_limit = nil #Not set by default. Parent object should make an informed decision.

	end

	def url=(value)
		@url = value
		@uri = URI.parse(@url)
	end

	#Fundamental REST API methods:
	def POST(data=nil)

		if not data.nil? #if request data passed in, use it.
			@data = data
		end

		uri = URI(@url)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		request = Net::HTTP::Post.new(uri.path)
		request.body = @data

		request['Authorization'] = "Bearer #{@bearer_token}"

		if not @headers.nil?
			@headers.each do | key, value|
				request[key] = value
			end
		end

		begin
			response = http.request(request)
		rescue
			logger()
			sleep 5
			response = http.request(request) #try again
		end

		@request_count =+ 1

		return response
	end

	def PUT(data=nil)

		if not data.nil? #if request data passed in, use it.
			@data = data
		end

		uri = URI(@url)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		request = Net::HTTP::Put.new(uri.path)
		request.body = @data

		request['Authorization'] = "Bearer #{@bearer_token}"

		begin
			response = http.request(request)
		rescue
			sleep 5
			response = http.request(request) #try again
		end

		@request_count =+ 1

		return response
	end

	def GET(params=nil)
		uri = URI(@url)

		#params are passed in as a hash.
		#Example: params["max"] = 100, params["since_date"] = 20130321000000
		if not params.nil?
			uri.query = URI.encode_www_form(params)
		end

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		request = Net::HTTP::Get.new(uri.request_uri)
		request['Authorization'] = "Bearer #{@bearer_token}"

		if not @headers.nil?
			@headers.each do | key, value|
				request[key] = value
			end
		end

		begin
			response = http.request(request)
		rescue
			sleep 5
			response = http.request(request) #try again
		end

		@request_count =+ 1

		return response
	end

	def DELETE(data=nil)
		if not data.nil?
			@data = data
		end

		uri = URI(@url)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		request = Net::HTTP::Delete.new(uri.path)
		request.body = @data

		request['Authorization'] = "Bearer #{@bearer_token}"

		begin
			response = http.request(request)
		rescue
			sleep 5
			response = http.request(request) #try again
		end

		@request_count =+ 1

		return response
	end
end #Requester class.
