require 'mailchimp'

class ApplicationController < ActionController::Base
  before_action :setup_mcapi
  rescue_from Mailchimp::Error, with: :mailchimp_error

  def setup_mcapi
    @mc = Mailchimp::API.new(ENV['API_KEY'])
  end
  
  private

  def mailchimp_error(ex)
    flash[:error] = (ex.message ? ex.message : "An unknown error occurred")
    redirect_to_back_or_default unless action_name == 'home'
  end

  def redirect_to_back_or_default(default = root_url)
    redirect_to request.env["HTTP_REFERER"].present? ? :back : default
  end

end
