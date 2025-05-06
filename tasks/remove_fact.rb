#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'
require 'facter'
require 'fileutils'

def set_fact(name, _value)
  # Cross platform to set facts_dir
  facts_dir = if Facter.value(:os)['family'] == 'windows'
                'C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\'
              else
                '/etc/puppetlabs/facter/facts.d/'
              end

  # Set some vars in a readable location
  file_name     = "#{name}.yaml"
  file_path     = "#{facts_dir}#{file_name}"

  # Create a file in facts_dir with the correct name and data
  raise Puppet::Error, "Fact doesn't exist at: #{facts_dir}" unless File.exist?(file_path)
  begin
    FileUtils.rm_f(file_path)
  rescue => e
    raise Puppet::Error, e
  end
  { status: 'success', message: 'Fact removed' }
end

# Find the desired setting from the JSON coming in over STDIN
params = JSON.parse(STDIN.read)
name   = params['name']
value  = params['value']

# Run the command with the desired setting, and return the result
begin
  result = set_fact(name, value)
  puts result.to_json
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', message: e.message }.to_json)
  exit 1
end
