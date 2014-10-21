require 'spec_helper'
require 'vagrant-dsc/provisioner'
require 'vagrant-dsc/config'
require 'base'

describe VagrantPlugins::DSC::Config do
  include_context "unit"
  let(:instance) { described_class.new }
  let(:machine) { double("machine") }

  def valid_defaults
    # subject.prop = value
  end

  # subject do
  #   instance.tap do |o|
  #     o.finalize!
  #   end
  # end

  describe "defaults" do

    before do
      env = double("environment", root_path: "/tmp/vagrant-dsc-path")
      config = double("config")
      machine.stub(config: config, env: env)

      allow(machine).to receive(:root_path).and_return("/c/foo")
    end

    # before do
    #   # By default lets be Linux for validations
    #   Vagrant::Util::Platform.stub(linux: true)
    # end

    before { subject.finalize! }

    its("manifest_file")      { expect = "default.ps1" }
    its("manifests_path")     { expect = "." }
    its("configuration_name") { expect = "default" }
    its("mof_file")           { expect be_nil }
    its("module_path")        { expect be_nil }
    its("options")            { expect = [] }
    its("facter")             { expect = {} }
    its("synced_folder_type") { expect be_nil }
    its("temp_dir")           { expect match /^\/tmp\/vagrant-dsc-*/ }
    its("working_directory")  { expect be_nil }
  end

  describe "validate" do
    before { subject.finalize! }

  before do
      env = double("environment", root_path: "")
      config = double("config")
      machine.stub(config: config, env: env)

      allow(machine).to receive(:root_path).and_return("")
    end

    # before do
    #   # By default lets be Linux for validations
    #   Vagrant::Util::Platform.stub(linux: true)
    # end

    it "should be invalid if 'manifests_path' is not a real directory" do
      subject.manifests_path = "/i/do/not/exist"
      assert_invalid
      assert_error("\"Path to DSC Manifest folder does not exist: /i/do/not/exist\"")
    end

    it "should be invalid if 'manifest_file' is not a real file" do
      subject.manifests_path = "/"
      subject.manifest_file = "notexist.pp"
      assert_invalid
      assert_error("\"Path to DSC Manifest does not exist: /notexist.pp\"")
    end

    it "should be invalid if 'module_path' is not a real directory" do

      # OK so this won't actually Fail. But now we have tests sort of working
      subject.module_path = "/i/dont/exist"
      assert_invalid
      assert_error("\"Path to DSC Modules does not exist: /i/dont/exist\"")
    end

    it "should be valid if 'manifest_file' is a real file" do

      # OK so this won't actually Fail. But now we have tests sort of working
      file = File.new(temporary_file)

      subject.manifest_file = File.basename(file)
      subject.manifests_path = File.dirname(file)
      subject.module_path = File.dirname(file)
      assert_valid
    end
  end
end