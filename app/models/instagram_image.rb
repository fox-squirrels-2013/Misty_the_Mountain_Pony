class InstagramImage < ActiveRecord::Base
  validates :link, uniqueness: true 
  has_and_belongs_to_many :tags

  def location
    [longitude, latitude]
  end
end


# class InstagramImage
#   def initialize(args)
#     @link = args[:link] || ''
#     @location = args[:location] || []
#     @likes = args[:likes] || 0
#     @created = args[:created] || ''
#     @thumbnail = args[:thumbnail] || ''
#     # @tags = args[:tags] || []
#     p @name
#   end


  # http://jsonlint.com/
#   def to_json
#     json  = "\"#{@link.split('/').last}\":"
#     json += "{ "
#     json += " \"link\": \"#{@link}\", "
#     json += " \"location\": \"#{@location}\","
#     json += " \"likes\": \"#{@likes}\","
#     json += " \"created\": \"#{@created}\","
#     json += " \"thumbnail\": \"#{@thumbnail}\""
#     # json += " \"tags\": \"#{@tags.gsub(/\"/, '\'')}\""
#     json += "} "
#     json
#   end
# end
