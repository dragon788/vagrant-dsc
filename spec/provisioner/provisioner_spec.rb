require 'spec_helper'
require 'vagrant-dsc/provisioner'
require 'vagrant-dsc/config'
require 'rspec/its'

describe VagrantPlugins::DSC::Provisioner do
  include_context "unit"

  let(:root_path)            { (Pathname.new(Dir.mktmpdir)).to_s }
  let(:machine)             { double("machine") }
  let(:env)                 { double("environment", root_path: root_path) }
  let(:vm)                  { double ("vm") }
  let(:configuration_file)  { "manifests/MyWebsite.ps1" }
  let(:manifests_path)      { "manifests" }
  let(:module_path)         { ["foo/modules", "foo/modules2"] }
  let(:root_config)         { VagrantPlugins::DSC::Config.new }
  subject                   { described_class.new machine, root_config }

  describe "configure" do
    before do
      allow(machine).to receive(:root_config).and_return(root_config)
      machine.stub(config: root_config, env: env)
      root_config.module_path = module_path
      root_config.configuration_file = configuration_file
      root_config.finalize!
      root_config.validate(machine)
    end

    it "when given default configuration, should share module and manifest folders with the guest" do
      allow(root_config).to receive(:vm).and_return(vm)
      expect(vm).to receive(:synced_folder).with("#{root_path}/manifests", /\/tmp\/vagrant-dsc-[0-9]+\/manifests/, {:owner=>"root"})
      expect(vm).to receive(:synced_folder).with("#{root_path}/foo/modules", /\/tmp\/vagrant-dsc-[0-9]+\/modules-0/, {:owner=>"root"})
      expect(vm).to receive(:synced_folder).with("#{root_path}/foo/modules2", /\/tmp\/vagrant-dsc-[0-9]+\/modules-1/, {:owner=>"root"})

      subject.configure(root_config)
    end

    it "when given a specific folder type, should modify folder options when sharing module and manifest folders with the guest" do
      root_config.synced_folder_type = "nfs"
      allow(root_config).to receive(:vm).and_return(vm)

      expect(vm).to receive(:synced_folder).with("#{root_path}/manifests", /\/tmp\/vagrant-dsc-[0-9]+\/manifests/, {:type=>"nfs"})
      expect(vm).to receive(:synced_folder).with("#{root_path}/foo/modules", /\/tmp\/vagrant-dsc-[0-9]+\/modules-0/, {:type=>"nfs"})
      expect(vm).to receive(:synced_folder).with("#{root_path}/foo/modules2", /\/tmp\/vagrant-dsc-[0-9]+\/modules-1/, {:type=>"nfs"})

      subject.configure(root_config)
    end

    it "when provided only manifests path, should only share manifest folders with the guest" do
      root_config.synced_folder_type = "nfs"
      root_config.module_path = nil
      allow(root_config).to receive(:vm).and_return(vm)

      expect(vm).to receive(:synced_folder).with("#{root_path}/manifests", /\/tmp\/vagrant-dsc-[0-9]+\/manifests/, {:type=>"nfs"})

      subject.configure(root_config)
    end

    it "should install DSC for supported OS's" do
      # Future
    end
  end

  describe "verify shared folders" do
    it "should " do

    end
  end

  describe "provision" do
    it "should create temporary folders on the guest" do

    end

    it "should ensure shared folders are properly configured" do

    end

    it "should verify DSC and Powershell versions are valid" do

    end

    it "should raise an error if DSC version is invalid" do

    end

    it "should raise an error if Powershell version is invalid" do

    end
  end

  describe "DSC runner script" do
    it "shoud generate a valid powershell command" do

    end

    it "should skip MOF file generation if one already provided" do

    end
  end

  describe "write DSC Runner script" do
    it "should upload the customised DSC runner to the guest" do

    end
  end

  describe "Apply DSC" do
    it "should notify the User that provisioning has commenced" do

    end

    it "should invoke the DSC runner as an elevated user" do

    end
  end
end