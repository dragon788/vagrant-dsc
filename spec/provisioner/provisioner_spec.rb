require 'spec_helper'
require 'vagrant-dsc/provisioner'
require 'rspec/its'

describe VagrantPlugins::DSC::Provisioner do
  let(:instance) { described_class.new }

  before { subject.finalize! }

  describe "defaults" do

  end
end