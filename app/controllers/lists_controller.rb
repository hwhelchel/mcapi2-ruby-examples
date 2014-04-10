class ListsController < ApplicationController
  rescue_from Mailchimp::ListDoesNotExistError, with: :does_not_exist
  rescue_from Mailchimp::ListAlreadySubscribedError, with: :already_subscribed

  def index
    lists_res = @mc.lists.list

    @lists = lists_res['data']
  end

  def show
    list_id = params[:id]
    lists_res = @mc.lists.list({'list_id' => list_id})
    members_res = @mc.lists.members(list_id)

    @list = lists_res['data'][0]
    @members = members_res['data']
  end

  def subscribe
    list_id = params[:id]
    email = params['email']
    @mc.lists.subscribe(params[:id], {'email' => email})

    flash[:success] = "#{email} subscribed successfully"
    redirect_to "/lists/#{list_id}"
  end

  private

  def does_not_exist
    flash[:error] = "The list could not be found"

    redirect_to_back_or_default
  end

  def already_subscribed
    email = params['email'] 
    flash[:error] = "#{email} is already subscribed to the list"
    
    redirect_to_back_or_default
  end
end
