require 'spec_helper'

describe ReportsController do

  let(:data) { ['abc'] }
  let(:error_message) { Mailchimp::Error.new.message }
  let(:params) { { id: 1 } }
  let(:report) { 'report' }
  describe '#index' do
    context 'successful api call' do

      before(:each) do
        Mailchimp::Campaigns.any_instance.stub(:list){{'data' => data }}
        get :index
      end

      it 'renders the index template' do
        expect(response).to render_template :index
      end

      it 'is ok' do
        expect(response).to be_ok
      end

      it 'assigns campaigns' do
        expect(assigns(:campaigns)).to eq data
      end
    end

    context 'when Mailchimp::Error is raised' do
      before(:each) do
        Mailchimp::Campaigns.any_instance.stub(:list){ raise Mailchimp::Error }
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
        Mailchimp::Campaigns.any_instance.stub(:list){{'data' => data }}
        Mailchimp::Reports.any_instance.stub(:summary){ report }
        get :show, params
      end

      it 'renders the show template' do
        expect(response).to render_template :show
      end

      it 'is ok' do
        expect(response).to be_ok
      end

      it 'assigns campaign' do
        expect(assigns(:campaign)).to eq data[0]
      end

      it 'assigns report' do
        expect(assigns(:report)).to eq report
      end
    end

    context 'when Mailchimp::Error is raised' do
      before(:each) do
        Mailchimp::Campaigns.any_instance.stub(:list){ raise Mailchimp::Error }
        get :show, params
      end

      it 'should redirect' do
        expect(response.status).to eq(302)
      end

      it 'should show appropriate error message' do
        expect(request.flash[:error]).to eq error_message
      end
    end
  end

end