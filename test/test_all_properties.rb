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

    http_mock = mock
    http_mock.stubs(:request).returns(fake_response)

    @properties.instance_variable_set(:@http, http_mock)
    
    assert_output("Beautiful House\nModern Apartment\n") do
      @properties.get_all
    end
	end

  def test_not_found
    fake_response = mock()
    fake_response.stubs(:code).returns("400")

    http_mock = mock
    http_mock.stubs(:request).returns(fake_response)

    @properties.instance_variable_set(:@http, http_mock)
    
    assert_output("Properties Not Found.\n") do
      @properties.get_all
    end
  end
end