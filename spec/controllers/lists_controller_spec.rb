require 'spec_helper'

describe ListsController do

  let(:params) do 
    {
      :id => 1,
      'email' =>'test@example.com'
    }
  end
  
  describe '#index' do
    before(:each) { get :index }
    context 'successful api call' do
      
      it 'renders the index view' do
        expect(response).to render_template "index"
      end

      it 'is ok' do
        expect(response).to be_ok
      end
    end

    context 'Mailchimp::Error raised' do
      before(:each) { Mailchimp::Lists.any_instance.stub(:list){ raise Mailchimp::Error }}
      before(:each) { get :index }
      it 'redirects' do
        expect(response.status).to eq(302)
      end
    end
  end


  describe '#show' do
    context 'Mailchimp::Error raised' do
      it 'redirects' do
        Mailchimp::Lists.any_instance.stub(:list){ raise Mailchimp::Error }
        get :show, params
        expect(response.status).to eq(302)
      end
    end

    context 'Mailchimp::ListDoesNotExistError raised' do
      it 'redirects' do
        Mailchimp::Lists.any_instance.stub(:list){ raise Mailchimp::ListDoesNotExistError }
        get :show, params
        expect(response.status).to eq(302)
      end
    end
  end

  describe '#subscribe' do
    context 'when Mailchimp::Error raised' do
      it 'should redirect' do
        Mailchimp::Lists.any_instance.stub(:subscribe){ raise Mailchimp::Error }
        post :subscribe, params
        expect(response.status).to eq(302)
      end
    end

    context 'when Mailchimp::ListDoesNotExistError raised' do
      it 'should redirect' do
        Mailchimp::Lists.any_instance.stub(:subscribe){ raise Mailchimp::ListDoesNotExistError }
        post :subscribe, params
        expect(response.status).to eq(302)
      end
    end

    context 'when Mailchimp::ListAlreadySubscribedError raised' do
      it 'should redirect' do
        Mailchimp::Lists.any_instance.stub(:subscribe){ raise Mailchimp::ListAlreadySubscribedError }
        post :subscribe, params
        expect(response.status).to eq(302)
      end
    end
  end
end