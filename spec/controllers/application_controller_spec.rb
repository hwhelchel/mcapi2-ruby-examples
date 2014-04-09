require 'spec_helper'

describe ApplicationController do

  describe '#setup_mcapi' do
    it 'returns a Mailchimp::API object' do
      expect(controller.setup_mcapi).to be_an_instance_of Mailchimp::API
    end
  end

end