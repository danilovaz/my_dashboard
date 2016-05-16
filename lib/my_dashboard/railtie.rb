module MyDashboard
  class Railtie < ::Rails::Railtie

    initializer 'configure assets' do |app|
      app.configure do
        config.assets.paths.unshift       MyDashboard::Engine.root.join('vendor', 'assets', 'fonts', 'my_dashboard')
        config.assets.paths.unshift       MyDashboard::Engine.root.join('vendor', 'assets', 'javascripts', 'my_dashboard')
        config.assets.paths.unshift       MyDashboard::Engine.root.join('vendor', 'assets', 'stylesheets', 'my_dashboard')
        config.assets.paths.unshift       MyDashboard.config.widgets_js_path
        config.assets.paths.unshift       MyDashboard.config.widgets_css_path

        config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
      end
    end

    initializer 'require my_dashboard jobs' do
      Dir[MyDashboard.config.jobs_path.join('**', '*.rb')].each { |file| require file }
    end

    initializer 'fix redis child connection' do
      if defined?(::PhusionPassenger)
        ::PhusionPassenger.on_event(:starting_worker_process) do |forked|
          if forked
            ::MyDashboard.redis.client.disconnect
            ::MyDashboard.redis.client.connect
          end
        end
      end
    end
  end
end
