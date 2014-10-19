require "vagrant/util/counter"
require "log4r"

module VagrantPlugins
  module DSC
    class Config < Vagrant.plugin("2", :config)
      extend Vagrant::Util::Counter

      attr_accessor :facter
      attr_accessor :mof_file
      attr_accessor :manifest_file
      attr_accessor :manifests_path
      attr_accessor :configuration_name
      attr_accessor :module_path
      attr_accessor :options
      attr_accessor :synced_folder_type
      attr_accessor :temp_dir
      attr_accessor :working_directory

      def initialize
        super

        @manifest_file      = UNSET_VALUE
        @manifests_path     = UNSET_VALUE
        @configuration_name = UNSET_VALUE
        @mof_file           = UNSET_VALUE
        @module_path        = UNSET_VALUE
        @options            = []
        @facter             = {}
        @synced_folder_type = UNSET_VALUE
        @temp_dir           = UNSET_VALUE
        @working_directory  = UNSET_VALUE

        @logger = Log4r::Logger.new("vagrant::vagrant_dsc")
      end

      def merge(other)
        super.tap do |result|
          result.facter  = @facter.merge(other.facter)
        end
      end

      def finalize!
        super

        @manifest_file      = "default.ps1" if @manifest_file == UNSET_VALUE
        @module_path        = nil if @module_path == UNSET_VALUE
        @synced_folder_type = nil if @synced_folder_type == UNSET_VALUE
        @temp_dir           = nil if @temp_dir == UNSET_VALUE
        @mof_file           = nil if @mof_file == UNSET_VALUE
        @working_directory  = nil if @working_directory == UNSET_VALUE
        @configuration_name = File.basename(@manifest_file, File.extname(@manifest_file)) if @configuration_name == UNSET_VALUE
        @manifests_path     = File.dirname(@manifest_file)

        # Set a default temp dir that has an increasing counter so
        # that multiple DSC definitions won't overwrite each other
        if !@temp_dir
          counter   = self.class.get_and_update_counter(:dsc_config)
          @temp_dir = "/tmp/vagrant-dsc-#{counter}"
        end
      end

      # Returns the module paths as an array of paths expanded relative to the
      # root path.
      def expanded_module_paths(root_path)
        return [] if !module_path

        # Get all the paths and expand them relative to the root path, returning
        # the array of expanded paths
        paths = module_path
        paths = [paths] if !paths.is_a?(Array)
        paths.map do |path|
          Pathname.new(path).expand_path(root_path)
        end
      end

      #
      # Validate configuration
      #
      def validate(machine)
        @logger.info("==> Configurin' DSC man!")
        errors = _detected_errors

        # Calculate the manifests and module paths based on env
        this_expanded_module_paths = expanded_module_paths(machine.env.root_path)

        # Manifest file validation

        if manifests_path[0].to_sym == :host
          expanded_path = Pathname.new(manifests_path[1]).
              expand_path(machine.env.root_path)
          if !expanded_path.directory?
            errors << I18n.t("vagrant_dsc.errors.manifests_path_missing",
                             path: expanded_path.to_s)
          else
            expanded_manifest_file = expanded_path.join(manifest_file)
            if !expanded_manifest_file.file? && !expanded_manifest_file.directory?
              errors << I18n.t("vagrant_dsc.errors.manifest_missing",
                               manifest: expanded_manifest_file.to_s)
            end
          end
        end

        { "dsc provisioner" => errors }
      end
    end
  end
end
