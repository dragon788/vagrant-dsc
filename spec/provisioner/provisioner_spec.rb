require 'spec_helper'
require 'vagrant-dsc/provisioner'
require 'vagrant-dsc/config'
require 'rspec/its'

describe VagrantPlugins::DSC::Provisioner do
  include_context "unit"

  let(:temp_dir) { (Pathname.new(Dir.mktmpdir)).to_s }
  let(:machine) { double("machine") }
  let(:env) { double("environment", root_path: temp_dir) }
  #let(:root_config) { double("root_config", temp_dir: "/tmp/vagrant-dsc-1", manifests_path: ".") }
  let(:vm) { double ("vm")}
  let(:manifests_path) { "manifests/MyWebsite.ps1" }
  let(:root_config) {
    config = VagrantPlugins::DSC::Config.new
    config.configuration_file = manifests_path
    config.module_path = "foo/modules"
    config.vm = vm
    config
  }
  subject { described_class.new machine, root_config  }

  describe "configure" do
    before do
      puts temp_dir
      allow(machine).to receive(:root_config).and_return(root_config)
      allow(root_config).to receive(:vm).and_return(vm)
      # env = double("environment", root_path: "/path/to/vagrant")
      # config = double("config")
      machine.stub(config: root_config, env: env)

      # allow(machine).to receive(:root_path).and_return("/c/foo")
      root_config.finalize!
      root_config.validate(machine)

      # allow(root_config).to receive(:expanded_module_paths).with("/path/to/vagrant") #{ [Pathname.new("/path/to/vagrant/dont/exist"), Pathname.new("/path/to/vagrant/also/dont/exist")] }
      # allow(root_config).to receive(:temp_dir).with("/path/to/vagrant") #{ [Pathname.new("/path/to/vagrant/dont/exist"), Pathname.new("/path/to/vagrant/also/dont/exist")] }

    end

    it "should setup the module paths for sharing" do

    end

    it "should determine the location of the manifest file on the guest" do

    end

    it "should share folders with the guest" do
      # Setup mock Config object

      # ynced_folder with ("/var/folders/kf/4sgp93ys2t3_9t3yyzr07c3r0000gn/T/d20141029-6108-w6pft9/manifests", "/tmp/vagrant-dsc-3/manifests", {:owner=>"root"})

      # root_config.vm.synced_folder(from, to, folder_opts)

      # Setup Mock for folders sync
      # expect(vm).to receive(:synced_folder).with("#{temp_dir}/manifests", "#{File.dirname(manifests_path)}/")
      expect(vm).to receive(:synced_folder).with("#{temp_dir}/manifests", "/tmp/vagrant-dsc-3/manifests", {:owner=>"root"})

      subject.configure(root_config)

      # expect(subject.expanded_module_paths).to eq(["#{temp_dir}/foo/modules"])

    end

    it "should install DSC for supported OS's" do

    end
  end

  describe "manifest path" do
    it "should find the correct path on the local guest" do

    end
  end

  describe "provision" do
    it "should ensure shared folders are properly configured" do

    end

    it "should verify DSC and Powershell versions are valid" do

    end

    describe "DSC runner script" do
      it "shoud generate a valid powershell command" do
      end

      it "should skip MOF file generation if one already provided" do

      end

    end

    describe "Apply DSC" do
      it "should" do
      end
    end

    describe "" do
      it "should" do
      end
    end
  end
end
