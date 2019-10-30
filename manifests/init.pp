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
  $facts_path              = $facter::params::facts_path,
  $fact_hash               = {},
  $disable_reserved_absent = false,
) inherits facter::params {

  # Create the folder if it doesn't exist
  exec { "mkdir -p ${facts_path}":
    path    => $facts['path'],
    creates => $facts_path,
  }

  # Setting facter facts via hiera:
  $fact_hash.each |$fact_name,$fact_value| {
    if $fact_value =~ Hash {
      # If fact_value is a hash, set ensure and value to those hash values with defaults
      $ensure = getvar('fact_value.ensure', 'present')
      $value  = getvar('fact_value.value',  '')
    }

    else {
      # If you turn off the reserved word, it's always present unless
      # explicitly set to absent via the $fact_value being a hash including
      # the key name "ensure"
      if $disable_reserved_absent {
        $ensure = 'present'
      }
      else {
        # Using the default behavior: cleaner way to remove facts
        # myfact: 'absent'
        if $fact_value == 'absent' { $ensure = 'absent' } else { $ensure = 'present'}
      }

      $value = $fact_value
    }

    facter::fact { $fact_name:
      ensure => $ensure,
      value  => $value,
    }
  }
}
