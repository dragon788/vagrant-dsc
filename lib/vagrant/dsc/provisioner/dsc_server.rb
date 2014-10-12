module VagrantPlugins
  module DSC
    module Provisioner
      class DSCServerError < Vagrant::Errors::VagrantError
        error_namespace("vagrant.provisioners.dsc_server")
      end

      class DSCServer < Vagrant.plugin("2", :provisioner)
        def provision
          if @machine.config.vm.communicator == :winrm
            raise Vagrant::Errors::ProvisionerWinRMUnsupported,
              name: "dsc_server"
          end

          verify_binary("dsc")
          run_dsc_agent
        end

        def verify_binary(binary)
          @machine.communicate.sudo(
            "which #{binary}",
            error_class: DSCServerError,
            error_key: :not_detected,
            binary: binary)
        end

        def run_dsc_agent
          options = config.options
          options = [options] if !options.is_a?(Array)

          # Intelligently set the dsc node cert name based on certain
          # external parameters.
          cn = nil
          if config.dsc_node
            # If a node name is given, we use that directly for the certname
            cn = config.dsc_node
          elsif @machine.config.vm.hostname
            # If a host name is given, we explicitly set the certname to
            # nil so that the hostname becomes the cert name.
            cn = nil
          else
            # Otherwise, we default to the name of the box.
            cn = @machine.config.vm.box
          end

          # Add the certname option if there is one
          options += ["--certname", cn] if cn

          # A shortcut to make things easier
          comm = @machine.communicate

          # If we have client certs specified, then upload them
          if config.client_cert_path && config.client_private_key_path
            @machine.ui.info(
              I18n.t("vagrant.provisioners.dsc_server.uploading_client_cert"))
            dirname = "/tmp/dsc-#{Time.now.to_i}-#{rand(1000)}"
            comm.sudo("mkdir -p #{dirname}")
            comm.sudo("mkdir -p #{dirname}/certs")
            comm.sudo("mkdir -p #{dirname}/private_keys")
            comm.sudo("chmod -R 0777 #{dirname}")
            comm.upload(config.client_cert_path, "#{dirname}/certs/#{cn}.pem")
            comm.upload(config.client_private_key_path,
              "#{dirname}/private_keys/#{cn}.pem")

            # Setup the options so that they point to our directories
            options << "--certdir=#{dirname}/certs"
            options << "--privatekeydir=#{dirname}/private_keys"
          end

          # Disable colors if we must
          if !@machine.env.ui.is_a?(Vagrant::UI::Colored)
            options << "--color=false"
          end

          # Build up the custom facts if we have any
          facter = ""
          if !config.facter.empty?
            facts = []
            config.facter.each do |key, value|
              facts << "FACTER_#{key}='#{value}'"
            end

            facter = "#{facts.join(" ")} "
          end

          options = options.join(" ")
          command = "#{facter}dsc agent --onetime --no-daemonize #{options} " +
            "--server #{config.dsc_server} --detailed-exitcodes || [ $? -eq 2 ]"

          @machine.ui.info I18n.t("vagrant.provisioners.dsc_server.running_dscd")
          @machine.communicate.sudo(command) do |type, data|
            if !data.chomp.empty?
              @machine.ui.info(data.chomp)
            end
          end
        end
      end
    end
  end
end
