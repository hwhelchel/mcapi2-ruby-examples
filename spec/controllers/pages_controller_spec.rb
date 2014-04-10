require 'spec_helper'

describe PagesController do

  let(:api_key_error_message){ "The API key is invalid. Update it in app/controllers/application_controller.rb" }
  let(:error_message){ Mailchimp::Error.new.message }
  describe '#home' do
    context 'successful api call' do
      before(:each) do
        Mailchimp::Helper.any_instance.stub(:ping){ true }
        get :home
      end

      it 'renders the home template' do
        expect(response).to render_template :home
      end

      it 'is ok' do
        expect(response).to be_ok
      end
    end

    context 'when Mailchimp::InvalidApiKeyError is raised' do
      before(:each) do
        Mailchimp::Helper.any_instance.stub(:ping){ raise Mailchimp::InvalidApiKeyError }
        get :home
      end

      it 'does not redirect' do
        expect(response.status).to_not eq(302)
      end

      it 'adds appropriate error message' do
        expect(request.flash[:error]).to eq api_key_error_message
      end
    end

    context 'when Mailchimp::Error is raised' do
      before(:each) do
        Mailchimp::Helper.any_instance.stub(:ping){ raise Mailchimp::Error }
        get :home
      end

      it 'does not redirect' do
        expect(response.status).to_not eq(302)
      end

      it 'adds the appropriate error message' do
        expect(request.flash[:error]).to eq error_message
      end
    end
  end

end