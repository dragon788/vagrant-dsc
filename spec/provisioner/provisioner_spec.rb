# require 'spec_helper'
# require 'vagrant-dsc/provisioner'
# require 'rspec/its'
#
# describe VagrantPlugins::DSC::Provisioner do
#   let(:instance) { described_class.new }
#
#   before { subject.finalize! }
#
#   describe "defaults" do
#     subject do
#       instance.tap do |o|
#         o.finalize!
#       end
#     end
#
#     its("manifest_file")      { expect = "default.ps1" }
#     its("manifests_path")     { expect = "." }
#     its("configuration_name") { expect = "default" }
#     its("mof_file")           { expect be_nil }
#     its("module_path")        { expect be_nil }
#     its("options")            { expect = [] }
#     its("facter")             { expect = {} }
#     its("synced_folder_type") { expect be_nil }
#     its("temp_dir")           { expect match /^\/tmp\/vagrant-dsc-*/ }
#     its("working_directory")  { expect be_nil }
#
#   end
# end
#
# #   describe "#vagrant_vagrantfile" do
# #     before { valid_defaults }
#
# #     it "should be valid if set to a file" do
# #       subject.vagrant_vagrantfile = temporary_file.to_s
# #       subject.finalize!
# #       assert_valid
# #     end
#
# #     it "should not be valid if set to a non-existent place" do
# #       subject.vagrant_vagrantfile = "/i/shouldnt/exist"
# #       subject.finalize!
# #       assert_invalid
# #     end
# #   end
# # end