require 'spec_helper'

describe PagesController do

  describe '#home' do
    context 'when Mailchimp::InvalidApiKeyError is raised' do
      it 'does not redirect' do
        Mailchimp::Helper.any_instance.stub(:ping){ raise Mailchimp::InvalidApiKeyError }
        get :home
        expect(response.status).to_not eq(302)
      end
    end

    context 'when Mailchimp::Error is raised' do
      it 'does not redirect' do
        Mailchimp::Helper.any_instance.stub(:ping){ raise Mailchimp::Error }
        get :home
        expect(response.status).to_not eq(302)
      end
    end
  end

end