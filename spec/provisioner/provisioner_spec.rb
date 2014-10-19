require 'spec_helper'
require 'vagrant-dsc/provisioner'

describe VagrantPlugins::DSC::Provisioner do
  # include_context "unit"

  describe "#guest_encrypted_data_bag_secret_key_path" do
    it "returns nil if host path is not configured" do
      allow(config).to receive(:manifest_path).and_return(nil)
      # expect(subject.guest_encrypted_data_bag_secret_key_path).to be_nil
    end

  end
end
