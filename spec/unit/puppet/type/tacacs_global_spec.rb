require 'spec_helper'
require 'puppet/type/tacacs_global'

RSpec.describe 'the tacacs_global type' do
  it 'loads' do
    expect(Puppet::Type.type(:tacacs_global)).not_to be_nil
  end
end