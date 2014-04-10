require 'spec_helper'

describe ListsController do

  let(:email){ 'test@example.com' }
  let(:params){ { :id => 1,'email' => email } }
  let(:data){ ['abc'] }
  let(:error_message){ Mailchimp::Error.new.message }
  let(:list_does_not_exist_message){ "The list could not be found" }
  let(:list_subscribed_error){ "#{email} is already subscribed to the list" }
  let(:success_message){ "#{email} subscribed successfully" }
  
  describe '#index' do
    context 'successful api call' do
      before(:each) do
        Mailchimp::Lists.any_instance.stub(:list){ { 'data' => data } }
        get :index
      end

      it 'renders the index view' do
        expect(response).to render_template "index"
      end

      it 'is ok' do
        expect(response).to be_ok
      end

      it 'assigns lists' do
        expect(assigns(:lists)).to eq data
      end
    end

    context 'when a Mailchimp::Error is raised' do
      before(:each) do
        Mailchimp::Lists.any_instance.stub(:list){ raise Mailchimp::Error }
        get :index
      end

      it 'should redirect' do
        expect(response.status).to eq(302)
      end

      it 'should show appropriate error message' do
        expect(request.flash[:error]).to eq error_message
      end
    end
  end


  describe '#show' do
    context 'successful api call' do
      before(:each) do
        Mailchimp::Lists.any_instance.stub(:list){ { 'data' => data } }
        Mailchimp::Lists.any_instance.stub(:members){ { 'data' => data } }
        get :show, params
      end

      it 'renders the show view' do
        expect(response).to render_template "show"
      end

      it 'is ok' do
        expect(response).to be_ok
      end

      it 'assigns lists' do
        expect(assigns(:list)).to eq data[0]
      end

      it 'assigns members' do
        expect(assigns(:members)).to eq data
      end
    end

    context 'when a Mailchimp::Error is raised' do
      before(:each) do
        Mailchimp::Lists.any_instance.stub(:list){ raise Mailchimp::Error }
        get :show, params
      end

      it 'should redirect' do
        expect(response.status).to eq(302)
      end


      it 'should show appropriate error message' do
        expect(request.flash[:error]).to eq error_message
      end
    end

    context 'when a Mailchimp::ListDoesNotExistError is raised' do
      before(:each) do
        Mailchimp::Lists.any_instance.stub(:list){ raise Mailchimp::ListDoesNotExistError }
        get :show, params
      end

      it 'should redirect' do
        expect(response.status).to eq(302)
      end

      it 'should show appropriate error message' do
        expect(request.flash[:error]).to eq list_does_not_exist_message
      end
    end
  end

  describe '#subscribe' do

    context 'successful api call' do
      before(:each) do
        Mailchimp::Lists.any_instance.stub(:subscribe){ true }
        post :subscribe, params
      end

      it 'should redirect' do
        expect(response.status).to eq(302)
      end

      it 'should show appropriate success message' do
        expect(request.flash[:success]).to eq success_message
      end
    end

    context 'when a Mailchimp::Error is raised' do

      before(:each) do
        Mailchimp::Lists.any_instance.stub(:subscribe){ raise Mailchimp::Error }
        post :subscribe, params
      end

      it 'should redirect' do
        expect(response.status).to eq(302)
      end

      it 'should show appropriate error message' do
        expect(request.flash[:error]).to eq error_message
      end
    end

    context 'when a Mailchimp::ListDoesNotExistError is raised' do

      before(:each) do
        Mailchimp::Lists.any_instance.stub(:subscribe){ raise Mailchimp::ListDoesNotExistError }
        post :subscribe, params
      end

      it 'should redirect' do
        expect(response.status).to eq(302)
      end

      it 'should show appropriate error message' do
        expect(request.flash[:error]).to eq list_does_not_exist_message
      end
    end

    context 'when a Mailchimp::ListAlreadySubscribedError is raised' do
      
      before(:each) do
        Mailchimp::Lists.any_instance.stub(:subscribe){ raise Mailchimp::ListAlreadySubscribedError }
        post :subscribe, params
      end

      it 'should redirect' do
        expect(response.status).to eq(302)
      end

      it 'should show appropriate error message' do
        expect(request.flash[:error]).to eq list_subscribed_error
      end
    end
  end
end