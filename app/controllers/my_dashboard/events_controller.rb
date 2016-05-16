module MyDashboard
  class EventsController < ApplicationController
    include ActionController::Live

    def index
      response.headers['Content-Type']      = 'text/event-stream'
      response.headers['X-Accel-Buffering'] = 'no'
      response.stream.write latest_events

      @redis = MyDashboard.redis
      @redis.psubscribe("#{MyDashboard.config.redis_namespace}.*") do |on|
        on.pmessage do |pattern, event, data|
          response.stream.write("data: #{data}\n\n")
        end
      end
    rescue IOError
      logger.info "[MyDashboard][#{Time.now.utc.to_s}] Stream closed"
    ensure
      @redis.quit
      response.stream.close
    end

    def latest_events
      events = MyDashboard.redis.hvals("#{MyDashboard.config.redis_namespace}.latest")
      events.map { |v| "data: #{v}\n\n" }.join
    end
  end
end
