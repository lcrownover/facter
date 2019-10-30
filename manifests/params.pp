# params.pp
class facter::params {

  # Set fact file path depending on OS
  case $facts['kernel'] {
    default:    { $facts_path = '/etc/puppetlabs/facter/facts.d/' }
    'windows':  { $facts_path = 'C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\' }
  }

}
