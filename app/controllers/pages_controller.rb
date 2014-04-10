class PagesController < ApplicationController
  rescue_from Mailchimp::InvalidApiKeyError, with: :api_key_error
  
  def home
    res = @mc.helper.ping
  end

  private

  def api_key_error
    flash[:error] = "The API key is invalid. Update it in app/controllers/application_controller.rb"
  end
  
end