module MyDashboard
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path('../../templates', __FILE__)

      desc 'Creates a MyDashboard initializer for your application.'

      def install
        route 'mount MyDashboard::Engine, at: MyDashboard.config.engine_path'
      end

      def copy_initializer
        template 'initializer.rb', 'config/initializers/my_dashboard.rb'
      end

      def copy_layout
        template 'layouts/dashboard.html.erb', 'app/views/layouts/my_dashboard/dashboard.html.erb'
      end

      def copy_dashboard
        template 'dashboards/sample.html.erb', 'app/views/my_dashboard/dashboards/sample.html.erb'
      end

      def copy_widget_manifests
        template 'widgets/index.css', 'app/assets/stylesheets/my_dashboard/widgets/index.css'
        template 'widgets/index.js', 'app/assets/javascripts/my_dashboard/widgets/index.js'
      end

      def copy_job
        template 'jobs/sample.rb', 'app/jobs/sample.rb'
      end

    end
  end
end
