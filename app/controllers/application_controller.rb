require 'mailchimp'

class ApplicationController < ActionController::Base
  before_action :setup_mcapi
  rescue_from Mailchimp::InvalidApiKeyError, with: :api_key_error
  rescue_from Mailchimp::Error, with: :mailchimp_error

  def setup_mcapi
    @mc = Mailchimp::API.new(ENV['API_KEY'])
  end
  
  private

  def mailchimp_error(ex)
    if ex.message
      flash[:error] = ex.message
    else
      flash[:error] = "An unknown error occurred"
    end
    redirect_to_back_or_default unless action_name == 'home'
  end

  def api_key_error(ex)
    flash[:error] = "The API key is invalid. Update it in app/controllers/application_controller.rb"
  end

  def redirect_to_back_or_default(default = root_url)
    if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back and return
    else
      redirect_to default and return
    end
  end

end
