# params.pp
class facter::params {

  # Set fact file path depending on OS
  case $facts['kernel'] {
    default:    { $facts_dir = '/etc/puppetlabs/facter/facts.d/' }
    'windows':  { $facts_dir = 'C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\' }
  }

}
