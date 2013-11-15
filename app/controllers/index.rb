require 'awesome_print'
require "sinatra"
require "instagram"

enable :sessions

CALLBACK_URL = "http://localhost:9393/oauth/callback"

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

get "/feed" do
  client = Instagram.client(:access_token => session[:access_token])
  client
  user = client.user
  # p user
  # sleep(3)
  # ap Instagram.user_search("ml3vi")
  graffitis = Instagram.tag_recent_media("sfx_graffiti")

  grs = graffitis.reject{|g| g[:location].nil? }

  ap grs

  grs.map! do |g|
    args = {}
    args[:location]     = [ g[:location][:latitude], g[:location][:longitude] ]
    args[:likes]        = g[:likes][:count]
    args[:link]         = g[:link]
    args[:created]      = g[:created_time]
    args[:thumbnail]    = g[:images][:thumbnail][:url]
    args[:tags]         = g[:tags]
    InstagramImage.new(args)
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



