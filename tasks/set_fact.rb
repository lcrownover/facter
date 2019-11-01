#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

def set_fact(name, value)
  # Cross platform to set facts_dir
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
  File.open(file_path, 'w'){|f| f.write(file_content)}
  raise Puppet::Error, _("Failed to write to path: #{file_path}") unless File.exist?(file_path)

  # Test the fact to see if it's working
  stdout, stderr, status = Open3.capture3(['facter',name])
  raise Puppet::Error, _("stderr: ' %{stderr}') % { stderr: stderr }") if status.exitstatus != 0

  # format a result
  result = { status: 'success', result: "Fact [#{name}] has been set to [#{value}]" }
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
  puts({ status: 'failure', error: e.message }.to_json)
  exit 1
rescue Exception => e
  puts e
end
