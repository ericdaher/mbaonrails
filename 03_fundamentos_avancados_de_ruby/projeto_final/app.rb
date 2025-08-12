require_relative 'monitor.rb'

m = monitor do
  site "https://www.google.com", alert_if: :status_not_200
  site "https://jsonplaceholder.typicode.com/todos/1", alert_if: :json_key_missing, key: "userId"
end

m.start