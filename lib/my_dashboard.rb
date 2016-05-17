module MyDashboard
  class << self

    delegate :scheduler, :redis, to: :config

    attr_accessor :configuration

    def config
      self.configuration ||= Configuration.new
    end

    def configure
      yield config if block_given?
    end

    def first_dashboard
      files = Dir[config.dashboards_views_path.join('*')].collect { |f| File.basename(f, '.*') }
      files.sort.first
    end

    def send_event(id, data)
      event = data.merge(id: id, updatedAt: Time.now.utc.to_i).to_json
      redis.hset("#{MyDashboard.config.redis_namespace}.latest", id, event)
      redis.publish("#{MyDashboard.config.redis_namespace}.create", event)
    end

  end
end

begin
  require 'rails'
rescue LoadError
end

$stderr.puts <<-EOC if !defined?(Rails)
warning: no framework detected.

Your Gemfile might not be configured properly.
---- e.g. ----
Rails:
    gem 'my_dashboard'

EOC

require 'my_dashboard/configuration'

if defined? Rails
  require 'my_dashboard/engine'
  require 'my_dashboard/railtie'
end
