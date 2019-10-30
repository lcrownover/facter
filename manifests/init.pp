# custom class is used to allow access to custom defined types, as well as providing hiera interfaces to those types
#
# ===================================================== #
# > facts hash used to set custom facts via hiera:
# custom::fact_hash:
#     pp_cluster: 'test_cluster'
#
# > or to ensure absent:
# custom::fact_hash:
#     pp_cluster:
#         ensure: 'absent'
#
# > or the magic way to ensure absent:
# custom::fact_hash:
#     pp_cluster: 'absent'
#
# ===================================================== #
#
class facter (
  $manage_facts_d_dir = true,
  $facts_path         = $facter::params::facts_path,
  $fact_hash          = {}
) inherits facter::params {

  # Management of facts_path
  if $manage_facts_d_dir {
    file { $facts_path:
      ensure => directory,
    }
  }

  # Setting facter facts via hiera:
  $fact_hash.each |$fact_name,$fact_value| {
    if $fact_value =~ Hash {
      # If fact_value is a hash, set ensure and value to those hash values with defaults
      $ensure = getvar('fact_value.ensure', 'present')
      $value  = getvar('fact_value.value',  '')
    }
    else {
      # Using the easy syntax
      if $fact_value == 'absent' { $ensure = 'absent' } else { $ensure = 'present'}
      $value = $fact_value
    }
    facter::fact { $fact_name:
      ensure => $ensure,
      value  => $value,
    }
  }
}
