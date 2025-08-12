require_relative 'site'

class MonitorDSL
  attr_reader :sites

  def initialize
    @sites = []
    @threads = []
  end

  def site(url, alert_if:, **options)
    @sites << Site.new(url, alert_if: alert_if, **options)
  end

  def start
    puts "Starting monitor with #{@sites.length} site(s):\n"
    
    @sites.each_with_index do |site, index|
      puts "#{index + 1}. #{site.url}"
      puts "   Alert condition: #{site.alert_if}"
      
      if site.options.any?
        puts "   Options: #{site.options.map { |k, v| "#{k}: #{v}" }.join(', ')}\n"
      end
      
      thread = Thread.new(site) do |site_obj|
        monitor_site(site_obj)
      end
      
      @threads << thread
    end
    
    loop do
      sleep 1
    end
  end

  private

  def monitor_site(site_obj)
    puts "Thread #{Thread.current.object_id} started for #{site_obj.url}"
    
    loop do
      result = site_obj.check_status
      if result[:alert]
        puts "[Thread #{Thread.current.object_id}] ALERT for #{site_obj.url}: #{result[:message]}"
      else
        puts "[Thread #{Thread.current.object_id}] OK for #{site_obj.url}: #{result[:message]}"
      end
      sleep 5
    end
  rescue => e
    puts "[Thread #{Thread.current.object_id}] Error monitoring #{site_obj.url}: #{e.message}"
  end
end

def monitor(&block)
  dsl = MonitorDSL.new
  dsl.instance_eval(&block)
  dsl
end