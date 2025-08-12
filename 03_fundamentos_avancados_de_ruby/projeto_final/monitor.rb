class MonitorDSL
  def initialize
    @sites = []
  end

  def site(url, alert_if:, **options)
    @sites << {
      url: url,
      alert_if: alert_if,
      options: options
    }
  end

  def sites
    @sites
  end
end

def monitor(&block)
  dsl = MonitorDSL.new
  dsl.instance_eval(&block)
  dsl
end