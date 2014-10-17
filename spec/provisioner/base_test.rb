require_relative "../../../../base"

require Vagrant.source_root.join("plugins/provisioners/chef/provisioner/base")

describe VagrantPlugins::DSC::Provisioner::Base do
  include_context "unit"

  describe "#guest_encrypted_data_bag_secret_key_path" do
    it "returns nil if host path is not configured" do
      allow(config).to receive(:encrypted_data_bag_secret_key_path).and_return(nil)
      allow(config).to receive(:provisioning_path).and_return("/tmp/foo")
      expect(subject.guest_encrypted_data_bag_secret_key_path).to be_nil
    end

    it "returns path under config.provisioning_path" do
      allow(config).to receive(:encrypted_data_bag_secret_key_path).and_return("secret")
      allow(config).to receive(:provisioning_path).and_return("/tmp/foo")
      expect(File.dirname(subject.guest_encrypted_data_bag_secret_key_path)).
        to eq "/tmp/foo"
    end
  end
end
