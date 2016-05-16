module MyDashboard
  module Generators
    class JobGenerator < ::Rails::Generators::NamedBase

      source_root File.expand_path('../../templates', __FILE__)

      desc 'Creates a new MyDashboard job.'

      def job
        template 'jobs/new.rb', "app/jobs/#{file_name}.rb"
      end

    end
  end
end
