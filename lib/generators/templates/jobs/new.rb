MyDashboard.scheduler.every '1s' do
  MyDashboard.send_event('widget_id', { value: rand(100) })
end
