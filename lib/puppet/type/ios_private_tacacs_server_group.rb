require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'ios_private_tacacs_server_group',
  docs: <<-EOS,
      This type provides Puppet with the capabilities to manage ...
    EOS
  features: ['remote_resource'],
  title_patterns: [
    {
      pattern: %r{^(?<name>[^\s]*) (?<address>.*)$},
      desc: 'Where the name and the virtual router are provided with a forward slash seperator',
    },
  ],
  attributes: {
    ensure: {
      type:    'Enum[present, absent]',
      desc:    'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type:      'String',
      desc:      'The name of the TACACS+ server you want to manage.',
      behaviour: :namevar,
    },
    address: {
      type:      'String',
      desc:      'The address of the TACACS+ private server you want to manage.',
      behaviour: :namevar,
    },
    nat: {
      type:      'Optional[Boolean]',
      desc:      'The name of the TACACS+ server you want to manage.',
    },
    single_connection: {
      type:      'Optional[Boolean]',
      desc:      'The name of the TACACS+ server you want to manage.',
    },
    port: {
      type:      'Optional[Integer]',
      desc:      'The name of the TACACS+ server you want to manage.',
    },
    timeout: {
      type:      'Optional[Integer]',
      desc:      'The name of the TACACS+ server you want to manage.',
    },
    key: {
      type:    'Optional[String]',
      desc:    'Encryption key (plaintext or in hash form depending on key_format)'
    },
    key_format: {
      type:      'Optional[Integer[0, 7]]',
      desc:      'The name of the TACACS+ server you want to manage.',
      default:   0,
    },
  },
)
