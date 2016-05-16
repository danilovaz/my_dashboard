module ControllerSpecHelpers
  def stub_scheduler(stubbed_scheduler)
    MyDashboard.config.stub(:scheduler).and_return(stubbed_scheduler)
  end

  def stub_redis(stubbed_redis)
    MyDashboard.config.stub(:redis).and_return(stubbed_redis)
  end
end
