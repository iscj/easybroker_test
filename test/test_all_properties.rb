require 'minitest/autorun'
require 'mocha/minitest'
require 'net/http'
require 'json'

require_relative '../all_properties'

class TestAllProperties < Minitest::Test
	def setup
		@properties = Properties.new 
	end

	def test_get_all_success_response
    fake_response = mock()
    fake_response.stubs(:code).returns("200")
    fake_response.stubs(:read_body).returns({
      "content" => [
        { "title" => "Beautiful House" },
        { "title" => "Modern Apartment" }
      ]
    }.to_json)

    Net::HTTP.stubs(:new).returns(mock_http(fake_response))
    
    assert_output("Beautiful House\nModern Apartment") do
      @properties.get_all
    end
	end


	private
	
	def mock_http(fake_response)
    mock = mock()
    mock.stubs(:request).returns(fake_response)
    mock
	end
end