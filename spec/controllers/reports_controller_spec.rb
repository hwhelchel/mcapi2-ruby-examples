require 'spec_helper'

describe ReportsController do

  before(:each){ Mailchimp::Campaigns.any_instance.stub(:list){ raise Mailchimp::Error } }
  describe '#index' do
    context 'when Mailchimp::Error is raised' do
      it 'should redirect' do
        get :index
        expect(response.status).to eq(302)
      end
    end
  end

  describe '#show' do
    context 'when Mailchimp::Error is raised' do
      it 'should redirect' do
        get :show, id: 1
        expect(response.status).to eq(302)
      end
    end
  end

end