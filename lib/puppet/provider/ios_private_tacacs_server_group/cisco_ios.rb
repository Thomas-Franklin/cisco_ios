require_relative '../../../puppet_x/puppetlabs/cisco_ios/check'
unless PuppetX::CiscoIOS::Check.use_old_netdev_type
  require_relative '../../util/network_device/cisco_ios/device'
  require_relative '../../../puppet_x/puppetlabs/cisco_ios/utility'

  # Register legacy Puppet provider instance for compatibility with other netdev_stdlib providers
  # Please do not do this with other Resource API based providers
  Puppet::Type.type(:tacacs_server_group).provide(:ios) do
  end

  # Tacacs Server Group Puppet Provider for Cisco IOS devices
  class Puppet::Provider::IosPrivateTacacsServerGroup::CiscoIos
    def self.commands_hash
      @commands_hash = PuppetX::CiscoIOS::Utility.load_yaml(File.expand_path(__dir__) + '/command.yaml')
    end

    def self.name_of_tacacs_server_group(output)
      output.scan(%r{aaa group server tacacs\+ (\S[^\n]*)}).flatten.first
    end

    def self.array_of_private_servers(output)
      output.scan(%r{server-private (.[^\s]*)}).flatten
    end

    def self.instances_from_cli(output)
      new_instance_fields = []
      output.scan(%r{#{PuppetX::CiscoIOS::Utility.get_instances(commands_hash)}}).each do |raw_instance_fields|
        tacacs_server_group_name = Puppet::Provider::IosPrivateTacacsServerGroup::CiscoIos.name_of_tacacs_server_group(raw_instance_fields)
        private_servers = Puppet::Provider::IosPrivateTacacsServerGroup::CiscoIos.array_of_private_servers(raw_instance_fields)
        private_servers.each do |server|
          new_instance = {}
          new_instance[:name] = tacacs_server_group_name
          new_instance[:address] = server
          new_instance[:title] = tacacs_server_group_name + " " + server
          new_instance[:ensure] = 'present'
          new_instance = new_instance.merge(PuppetX::CiscoIOS::Utility.parse_resource(raw_instance_fields.scan(%r{server-private #{server}.*}).first, commands_hash))
          new_instance.delete_if { |_k, v| v.nil? }
          new_instance_fields << new_instance
        end
      end
      new_instance_fields
    end

    def commands_hash
      Puppet::Provider::IosPrivateTacacsServerGroup::CiscoIos.commands_hash
    end

    def get(context, _names = nil)
      output = context.device.run_command_enable_mode(PuppetX::CiscoIOS::Utility.get_values(commands_hash))
      return [] if output.nil?
      return_value = Puppet::Provider::IosPrivateTacacsServerGroup::CiscoIos.instances_from_cli(output)
      PuppetX::CiscoIOS::Utility.enforce_simple_types(context, return_value)
    end

    def set(context, changes)
      changes.each do |name, change|
        is = if context.feature_support?('simple_get_filter')
               change.key?(:is) ? change[:is] : (get(context, [name]) || []).find { |r| r[:name] == name }
             else
               change.key?(:is) ? change[:is] : (get(context) || []).find { |r| r[:name] == name }
             end
        should = change[:should]
        is = { name: name, ensure: 'absent' } if is.nil?
        should = { name: name, ensure: 'absent' } if should.nil?
        if is[:ensure].to_s == 'absent' && should[:ensure].to_s == 'present'
          context.creating(name) do
            create(context, name, should)
          end
        elsif is[:ensure].to_s == 'present' && should[:ensure].to_s == 'present'
          context.updating(name) do
            update(context, name, is, should)
          end
        elsif is[:ensure].to_s == 'present' && should[:ensure].to_s == 'absent'
          context.deleting(name) do
            delete(context, name)
          end
        end
      end
    end

    def update(context, _name, is, should)
      
    end

    def delete(context, name)
      
    end

    def create(context, name, should)
      
    end

    def canonicalize(_context, resources)
      resources
    end
  end
end
