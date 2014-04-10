require 'mailchimp'

class ReportsController < ApplicationController

  def index
    campaigns_res = @mc.campaigns.list({:status=>'sent'})

    @campaigns = campaigns_res['data']
  end

  def show
    campaign_id = params[:id]
    campaign_res = @mc.campaigns.list({:campaign_id => campaign_id})
    
    @report = @mc.reports.summary(campaign_id)
    @campaign = campaign_res['data'][0]
  end

end
