module OmniAuth
  module Strategies
    class Twitter < OmniAuth::Strategies::OAuth
      def request_phase
        force_login = session['omniauth.params'] ? session['omniauth.params']['force_login'] : nil
        screen_name = session['omniauth.params'] ? session['omniauth.params']['screen_name'] : nil
        x_auth_access_type = session['omniauth.params'] ? session['omniauth.params']['x_auth_access_type'] : nil
        if force_login && !force_login.empty?
          options[:authorize_params] ||= {}
          options[:authorize_params].merge!(:force_login => 'true')
        end
        if screen_name && !screen_name.empty?
          options[:authorize_params] ||= {}
          options[:authorize_params].merge!(:force_login => 'true', :screen_name => screen_name)
        end
        if x_auth_access_type
          options[:request_params] || {}
          options[:request_params].merge!(:x_auth_access_type => x_auth_access_type)
        end

        if session['omniauth.params'] && session['omniauth.params']["use_authorize"] == "true"
          options.client_options.authorize_path = '/oauth/authorize'
        else
          options.client_options.authorize_path = '/oauth/authenticate'
        end
        old_request_phase
      end
    end
  end
end

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end
