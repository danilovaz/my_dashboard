Rails.application.routes.draw do
  mount MyDashboard::Engine, at: MyDashboard.config.engine_path
end
