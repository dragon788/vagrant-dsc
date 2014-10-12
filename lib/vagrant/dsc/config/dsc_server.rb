module VagrantPlugins
  module DSC
    module Config
      class DSCServer < Vagrant.plugin("2", :config)
        attr_accessor :client_cert_path
        attr_accessor :client_private_key_path
        attr_accessor :facter
        attr_accessor :options
        attr_accessor :dsc_server
        attr_accessor :dsc_node

        def initialize
          super

          @client_cert_path        = UNSET_VALUE
          @client_private_key_path = UNSET_VALUE
          @facter                  = {}
          @options                 = []
          @dsc_node             = UNSET_VALUE
          @dsc_server           = UNSET_VALUE
        end

        def merge(other)
          super.tap do |result|
            result.facter  = @facter.merge(other.facter)
          end
        end

        def finalize!
          super

          @client_cert_path = nil if @client_cert_path == UNSET_VALUE
          @client_private_key_path = nil if @client_private_key_path == UNSET_VALUE
          @dsc_node   = nil if @dsc_node == UNSET_VALUE
          @dsc_server = "dsc" if @dsc_server == UNSET_VALUE
        end

        def validate(machine)
          errors = _detected_errors

          if (client_cert_path && !client_private_key_path) ||
            (client_private_key_path && !client_cert_path)
            errors << I18n.t(
              "vagrant.provisioners.dsc_server.client_cert_and_private_key")
          end

          if client_cert_path
            path = Pathname.new(client_cert_path).
              expand_path(machine.env.root_path)
            if !path.file?
              errors << I18n.t(
                "vagrant.provisioners.dsc_server.client_cert_not_found")
            end
          end

          if client_private_key_path
            path = Pathname.new(client_private_key_path).
              expand_path(machine.env.root_path)
            if !path.file?
              errors << I18n.t(
                "vagrant.provisioners.dsc_server.client_private_key_not_found")
            end
          end

          if !dsc_node && (client_cert_path || client_private_key_path)
            errors << I18n.t(
              "vagrant.provisioners.dsc_server.cert_requires_node")
          end

          { "dsc server provisioner" => errors }
        end
      end
    end
  end
end
