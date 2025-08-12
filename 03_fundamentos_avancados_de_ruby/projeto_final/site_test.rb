require 'minitest/autorun'
require_relative 'site'

class SiteTest < Minitest::Test
  def test_valid_url_returns_200_no_alert
    site = Site.new("https://httpbin.org/status/200", alert_if: :status_not_200)
    result = site.check_status
    
    refute result[:alert], "Should not trigger alert for correct status"
    assert_equal "Status OK (200)", result[:message]
  end

  def test_url_returns_404_triggers_alert
    site = Site.new("https://httpbin.org/status/404", alert_if: :status_not_200)
    result = site.check_status
    
    assert result[:alert], "Should trigger alert for incorrect status"
    assert_equal "Status code 404 instead of 200", result[:message]
  end

  def test_url_returns_500_triggers_alert
    site = Site.new("https://httpbin.org/status/500", alert_if: :status_not_200)
    result = site.check_status
    
    assert result[:alert], "Should trigger alert for 500 status"
    assert_equal "Status code 500 instead of 200", result[:message]
  end

  def test_expecting_404_gets_404_no_alert
    site = Site.new("https://httpbin.org/status/404", alert_if: :status_not_404)
    result = site.check_status
    
    refute result[:alert], "Should not trigger alert when expecting 404 and getting 404"
    assert_equal "Status OK (404)", result[:message]
  end

  def test_expecting_201_gets_200_triggers_alert
    site = Site.new("https://httpbin.org/status/200", alert_if: :status_not_201)
    result = site.check_status
    
    assert result[:alert], "Should trigger alert when expecting 201 but getting 200"
    assert_equal "Status code 200 instead of 201", result[:message]
  end

  def test_site_with_options
    site = Site.new("https://httpbin.org/status/200", alert_if: :status_not_200, timeout: 30, retries: 3)
    
    assert_equal "https://httpbin.org/status/200", site.url
    assert_equal :status_not_200, site.alert_if
    assert_equal({timeout: 30, retries: 3}, site.options)
  end

  def test_invalid_url_handles_error_gracefully
    site = Site.new("https://invalid-domain-that-doesnt-exist.com", alert_if: :status_not_200)
    result = site.check_status
    
    assert result[:alert], "Should trigger alert for network errors"
    assert_equal result[:message], "Something went wrong when reaching the URI."
  end

  def test_unknown_alert_condition
    site = Site.new("https://httpbin.org/status/200", alert_if: :unknown_condition)
    result = site.check_status
    
    refute result[:alert], "Should not trigger alert for unknown conditions"
    assert_equal "Unknown alert condition: unknown_condition", result[:message]
  end

  def test_json_key_missing_key_exists
    site = Site.new("https://jsonplaceholder.typicode.com/todos/1", alert_if: :json_key_missing, key: "userId")
    result = site.check_status
    
    refute result[:alert], "Should not trigger alert when key exists"
    assert_equal "JSON key 'userId' found", result[:message]
  end

  def test_json_key_missing_key_does_not_exist
    site = Site.new("https://jsonplaceholder.typicode.com/todos/1", alert_if: :json_key_missing, key: "nonexistent")
    result = site.check_status
    
    assert result[:alert], "Should trigger alert when key is missing"
    assert_equal "JSON key 'nonexistent' is missing", result[:message]
  end

  def test_json_key_missing_no_key_specified
    site = Site.new("https://jsonplaceholder.typicode.com/todos/1", alert_if: :json_key_missing)
    result = site.check_status
    
    assert result[:alert], "Should trigger alert when no key is specified"
    assert_equal "No key specified for json_key_missing check", result[:message]
  end

  def test_json_key_missing_multiple_keys_exist
    site = Site.new("https://jsonplaceholder.typicode.com/todos/1", alert_if: :json_key_missing, key: "title")
    result = site.check_status
    
    refute result[:alert], "Should not trigger alert when 'title' key exists"
    assert_equal "JSON key 'title' found", result[:message]
  end

  def test_json_key_missing_boolean_key
    site = Site.new("https://jsonplaceholder.typicode.com/todos/1", alert_if: :json_key_missing, key: "completed")
    result = site.check_status
    
    refute result[:alert], "Should not trigger alert when 'completed' key exists"
    assert_equal "JSON key 'completed' found", result[:message]
  end
end