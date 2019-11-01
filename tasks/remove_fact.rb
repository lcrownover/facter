#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'
require 'fileutils'

def set_fact(name, value)
  #Cross platform to set facts_dir
  if Facter.value(:os)['family'] == 'windows'
    facts_dir = 'C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\'
  else
    facts_dir = '/etc/puppetlabs/facter/facts.d/'
  end

  # Set some vars in a readable location
  file_name     = "#{name}.yaml"
  file_content  = "#{name}: '#{value}'\n"
  file_path     = "#{facts_dir}#{file_name}"

  # Create a file in facts_dir with the correct name and data
  if File.exist?(file_path)
    begin
      FileUtils.rm_f(file_path)
    rescue => e
      raise Puppet::Error, _("stderr": "Failed to remove file at: #{facts_dir}")
    end
  else
    raise Puppet::Error, _("stderr": "Fact doesn't exist at: #{facts_dir}")
  end
  { status: 'success', msg: 'Fact removed' }
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
  puts({ _error: { kind: 'facter::set_task/failure', msg: e.message }}.to_json)
  exit 1
end
