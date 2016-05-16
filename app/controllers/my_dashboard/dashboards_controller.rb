module MyDashboard
  class DashboardsController < ApplicationController

    before_filter :check_dashboard_name, only: :show

    rescue_from ActionView::MissingTemplate, with: :template_not_found

    def index
      render file: dashboard_path(MyDashboard.config.default_dashboard || MyDashboard.first_dashboard || ''), layout: MyDashboard.config.dashboard_layout_path
    end

    def show
      render file: dashboard_path(params[:name]), layout: MyDashboard.config.dashboard_layout_path
    end

    private

    def check_dashboard_name
      raise 'bad dashboard name' unless params[:name] =~ /\A[a-zA-z0-9_\-]+\z/
    end

    def dashboard_path(name)
      MyDashboard.config.dashboards_views_path.join(name)
    end

    def template_not_found
      raise "Count not find template for dashboard '#{params[:name]}'. Define your dashboard in #{dashboard_path('')}"
    end

  end
end
