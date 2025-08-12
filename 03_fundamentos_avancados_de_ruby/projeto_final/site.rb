require 'net/http'
require 'uri'
require 'json'

class Site
  REQUEST_TIMEOUT = 3
  attr_reader :url, :alert_if, :options

  def initialize(url, alert_if:, **options)
    @url = url
    @alert_if = alert_if
    @options = options
  end

  def check_status
    response = make_request
    
    return { alert: true, message: response[:error] } if response.is_a?(Hash) && response[:error]
    
    if @alert_if.to_s.match(/^status_not_(\d+)$/)
      handle_status_alert(response)
    elsif @alert_if == :json_key_missing
      handle_json_key_alert(response)
    else
      { alert: false, message: "Unknown alert condition: #{@alert_if}" }
    end
  end

  private

  def make_request
    uri = URI(@url)
    
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', open_timeout: REQUEST_TIMEOUT, read_timeout: REQUEST_TIMEOUT) do |http|
      request = Net::HTTP::Get.new(uri)
      http.request(request)
    end
  rescue
    { error: "Something went wrong when reaching the URI." }
  end

  def handle_status_alert(response)
    expected_status = @alert_if.to_s.match(/^status_not_(\d+)$/)[1]
    if response.code != expected_status
      { alert: true, message: "Status code #{response.code} instead of #{expected_status}" }
    else
      { alert: false, message: "Status OK (#{expected_status})" }
    end
  end

  def handle_json_key_alert(response)
    begin
      json_data = JSON.parse(response.body)
      key_to_check = @options[:key]
      
      if key_to_check.nil?
        { alert: true, message: "No key specified for json_key_missing check" }
      elsif json_data.key?(key_to_check.to_s)
        { alert: false, message: "JSON key '#{key_to_check}' found" }
      else
        { alert: true, message: "JSON key '#{key_to_check}' is missing" }
      end
    rescue JSON::ParserError => e
      { alert: true, message: "Failed to parse JSON: #{e.message}" }
    end
  end
end