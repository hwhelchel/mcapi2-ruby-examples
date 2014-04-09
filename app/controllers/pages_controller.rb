class PagesController < ApplicationController
  
  def home
    res = @mc.helper.ping
  end
  
end