require 'rufus-scheduler'
require 'redis'
require 'connection_pool'

module MyDashboard
  class Configuration

    attr_reader   :redis
    attr_accessor :redis_host, :redis_port, :redis_password, :redis_namespace, :redis_timeout
    attr_accessor :auth_token, :devise_allowed_models
    attr_accessor :jobs_path
    attr_accessor :default_dashboard, :dashboards_views_path, :dashboard_layout_path
    attr_accessor :widgets_views_path, :widgets_js_path, :widgets_css_path
    attr_accessor :engine_path, :scheduler

    def initialize
      @engine_path            = '/my_dashboard'
      @scheduler              = ::Rufus::Scheduler.new

      # Redis
      @redis_host             = '127.0.0.1'
      @redis_port             = '6379'
      @redis_password         = nil
      @redis_namespace        = 'my_dashboard_events'
      @redis_timeout          = 3

      # Authorization
      @auth_token             = nil
      @devise_allowed_models  = []

      # Jobs
      @jobs_path              = Rails.root.join('app', 'jobs')

      # Dashboards
      @default_dashboard      = nil
      @dashboards_views_path  = Rails.root.join('app', 'views', 'my_dashboard', 'dashboards')
      @dashboard_layout_path  = 'my_dashboard/dashboard'

      # Widgets
      @widgets_views_path     = Rails.root.join('app', 'views', 'my_dashboard', 'widgets')
      @widgets_js_path        = Rails.root.join('app', 'assets', 'javascripts', 'my_dashboard')
      @widgets_css_path       = Rails.root.join('app', 'assets', 'stylesheets', 'my_dashboard')
    end

    def redis
      @redis ||= ::ConnectionPool::Wrapper.new(size: request_thread_count, timeout: redis_timeout) { new_redis_connection }
    end

    def new_redis_connection
      ::Redis.new(host: redis_host, port: redis_port, password: redis_password)
    end

    private

    def request_thread_count
      if defined?(::Puma) && ::Puma.respond_to?(:cli_config)
        ::Puma.cli_config.options.fetch(:max_threads, 5).to_i
      else
        5
      end
    end
  end
end
