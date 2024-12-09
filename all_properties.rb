
require 'net/http'
require 'json'

class Properties
  BASE_URL = "https://api.stagingeb.com/v1/properties?page=1&limit=20"
  API_KEY = ENV["EASYBROKER_API_KEY"]

  def initialize
    @uri = URI(BASE_URL)
    @http = Net::HTTP.new(@uri.host, @uri.port)
    @http.use_ssl = true
  end

  def get_all
    request = Net::HTTP::Get.new(@uri)
    request["accept"] = 'application/json'
    request["X-Authorization"] = API_KEY
    response = @http.request(request)

    if response.code == "200"
      data = JSON.parse(response.read_body)
    
      if data['content']
        data['content'].each do |property|
          puts "#{property["title"]}"
        end
      end
    else
      puts "Properties Not Found."
    end
  end
end

properties_api = Properties.new
properties_api.get_all