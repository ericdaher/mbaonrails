# Website Monitoring DSL

A Ruby DSL for website monitoring that allows defining sites to monitor with various alert conditions.

## What We've Implemented

### Basic DSL Structure
- **MonitorDSL class**: Core class that handles site definitions and stores monitoring configuration
- **monitor method**: Top-level method that accepts a block and creates a DSL instance using `instance_eval`
- **site method**: Method for defining sites to monitor with URL and alert conditions

### Current Syntax
```ruby
monitor do
  site "https://example.com", alert_if: :status_not_200
  site "https://api.example.com/data", alert_if: :json_key_missing, key: "users"
end
```

### Features
- Support for multiple alert conditions (`:status_not_200`, `:json_key_missing`)
- Additional parameters for complex alert conditions (e.g., `key:` parameter)
- Clean, readable DSL syntax
- Stores all site configurations for later processing

## What's Next

### Planned Enhancements
1. **Enumerable Integration**: Add methods to iterate and filter monitoring configurations
2. **Concurrent Programming**: Implement parallel monitoring of multiple sites
3. **Alert System**: Build actual monitoring logic that checks sites and triggers alerts
4. **Extended Alert Types**: Add more alert conditions (response time, content matching, etc.)
5. **Configuration Management**: Add ways to load/save monitoring configurations

### Advanced Ruby Features to Explore
- **Enumerable module**: For filtering and processing site collections
- **Threads/Fibers**: For concurrent site monitoring
- **Method chaining**: For more fluent API design
- **Metaprogramming**: For dynamic alert condition creation