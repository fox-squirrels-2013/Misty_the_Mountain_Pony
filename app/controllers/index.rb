require 'awesome_print'
require "sinatra"
require "instagram"

enable :sessions

CALLBACK_URL = "http://localhost:9393/oauth/callback"

Instagram.configure do |config|
  config.client_id = "c992d684703e4aa198c64adab13039d0"
  config.client_secret = "295b353a3e0a491ea3e6b4478c8eca15"
end

get "/" do
  '<a href="/oauth/connect">Connect with Instagram</a>'
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/feed"
end

get "/feed/:tag" do
  client = Instagram.client(:access_token => session[:access_token])

  user = client.user

  # ap Instagram.user_search("ml3vi")
  graffitis = Instagram.tag_recent_media("#{params[:tag]}")

  grs = graffitis.reject{|g| g[:location].nil? }

  ap grs

  grs.map! do |g|
    args = {}
    args[:latitude]     = g[:location][:latitude]
    args[:longitude]    = g[:location][:longitude]
    args[:likes]        = g[:likes][:count]
    args[:link]         = g[:link]
    args[:created]      = g[:created_time]
    args[:thumbnail]    = g[:images][:thumbnail][:url]
    args[:tags]         = g[:tags]#.map {|t| Tag.create(t)}
    InstagramImage.create(args)
  end

  ap grs

# img.location.latitude
# img.location.longitude
# img.likes.count
# img.link
# img.created_time
# img.images.thumbnail.url
# img.tags

  # latlongArray = grs.map do |g|
  #   lat = g[:location][:latitude]
  #   lon = g[:location][:longitude]
  #   "'name' : [#{lat}, #{lon} ]"
  # end

  # out = "{" + latlongArray.join(',') + "}"
  # ap out


  '{' + grs.map(&:to_json).join(',')  +'}'

end


class InstagramImage
  def initialize(args)
    @link = args[:link] || ''
    @location = args[:location] || []
    @likes = args[:likes] || 0
    @created = args[:created] || ''
    @thumbnail = args[:thumbnail] || ''
    # @tags = args[:tags] || []
    p @name
  end


  # http://jsonlint.com/
  def to_json
    json  = "\"#{@link.split('/').last}\":"
    json += "[ "
    json += " \"link\": \"#{@link}\", "
    json += " \"location\": \"#{@location}\","
    json += " \"likes\": \"#{@likes}\","
    json += " \"created\": \"#{@created}\","
    json += " \"thumbnail\": \"#{@thumbnail}\""
    # json += " \"tags\": \"#{@tags.gsub(/\"/, '\'')}\""
    json += "] "
    json
  end
end


