module MyDashboard
  class ApplicationController < ActionController::Base

    before_filter :authentication_with_devise

    private

    def authentication_with_devise
      MyDashboard.config.devise_allowed_models.each do |model|
        self.send("authenticate_#{model.to_s}!")
      end
    end

    def check_accessibility
      auth_token = params.delete(:auth_token)
      if !MyDashboard.config.auth_token || auth_token == MyDashboard.config.auth_token
        true
      else
        render nothing: true, status: 401 and return
      end
    end
  end
end
