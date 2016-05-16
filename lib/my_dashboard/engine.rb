module MyDashboard
  class Engine < ::Rails::Engine
    isolate_namespace MyDashboard

    paths['app/views'].unshift MyDashboard::Engine.root.join('app', 'views', 'my_dashboard', 'widgets')
  end
end
