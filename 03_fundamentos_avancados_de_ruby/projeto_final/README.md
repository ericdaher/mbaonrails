# Website Monitoring DSL

A Ruby DSL for website monitoring that allows defining sites to monitor with various alert conditions.
Each site is monitored by an individual thread, and the status is printed to the terminal.

### Usage
```ruby
monitor do
  site "https://example.com", alert_if: :status_not_200
  site "https://api.example.com/data", alert_if: :json_key_missing, key: "users"
end
```

### Example

Just run `ruby app.rb`.
