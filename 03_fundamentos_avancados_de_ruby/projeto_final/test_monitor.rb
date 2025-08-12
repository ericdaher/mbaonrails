require_relative 'monitor'

result = monitor do
  site "https://example.com", alert_if: :status_not_200
  site "https://api.example.com/data", alert_if: :json_key_missing, key: "users"
end

puts "Monitor DSL test:"
puts "Number of sites: #{result.sites.length}"
result.sites.each_with_index do |site, index|
  puts "Site #{index + 1}:"
  puts "  URL: #{site[:url]}"
  puts "  Alert condition: #{site[:alert_if]}"
  puts "  Options: #{site[:options]}" unless site[:options].empty?
end