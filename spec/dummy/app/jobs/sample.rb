current_valuation = 0

MyDashboard.scheduler.every '2s' do
  last_valuation = current_valuation
  current_valuation = rand(100)

  MyDashboard.send_event('valuation', { current: current_valuation, last: last_valuation })
  MyDashboard.send_event('synergy',   { value: rand(100) })
end
