require 'spec_helper'
require 'puppet/type/ios_private_tacacs_server_group'

RSpec.describe 'the ios_private_tacacs_server_group type' do
  it 'loads' do
    expect(Puppet::Type.type(:ios_private_tacacs_server_group)).not_to be_nil
  end
end
