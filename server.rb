require 'sinatra'
require_relative 'docker_client'

class Server < Sinatra::Base
	CONTAINERS = Hash.new

	get '/' do
		content_type :json
		blobs = []
		body = {data: blobs}
		CONTAINERS.each do |user, client|
			blobs << JSON.parse(client.to_json)
		end
		body.to_json
	end

	get '/create/:user/:scenario' do
		user = params[:user].to_s
		scenario = params[:scenario].to_s

		CONTAINERS[user] = DockerClient.new(user, scenario)
		CONTAINERS[user].start
		"Container started"
		redirect '/'
	end

	get '/destroy/:user' do
		user = params[:user]
		if CONTAINERS.has_key? user.to_s
			CONTAINERS[user].stop
			CONTAINERS.delete(user)
			"Container stopped"
		else
			"Container doesn't exist"
		end
		redirect '/'
	end

end
