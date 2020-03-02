# @summary
#   Allows users to add an external fact file in yaml format
#
# @example
#   facter::fact { 'pp_cluster':
#     value => 'web'
#   }
#
# @param ensure
#   valid options are 'present' or 'absent'. Defaults to 'present'
#
# @param value
#   value of the fact to be set
#
define facter::fact (
  Enum['present','absent']        $ensure    = 'present',
  Optional[String]                $file_name = undef,
  Variant[String, Boolean, Undef] $value     = undef,
) {

  # Make sure the class has been defined to access its data
  if ! defined(Class['facter']) {
    fail('Class "facter" must be included before using its defined types')
  }

  $facts_dir = $::facter::facts_dir

  # Parameter validation on fact name regardless of present or absent
  if $title !~ /[a-z0-9_]+/ {
    fail("facter::fact::${title} must begin with a lowercase letter and can only include letters, digits, and underscores")
  }

  # Parameter validation for filename if specified
  if $file_name {
    $fact_file_name = $file_name
    if $fact_file_name !~ /[a-z0-9_]+/ {
      fail("${fact_file_name} must begin with a lowercase letter and can only include letters, digits, and underscores")
    }
  }
  else { $fact_file_name = $title }

  case $ensure {
    'present': {
      # Parameter validation on fact value only if it's present
      if $value !~ /[a-z0-9_]*/ {
        fail("facter::fact::${title}: '${value}' must begin with a lowercase letter and can only include letters, digits, and underscores")
      }
      # Put the fact in place
      file { "${facts_dir}${fact_file_name}.yaml":
        ensure  => $ensure,
        content => "${title}: ${value}\n",
      }
    }#present

    'absent': {
      file { "${facts_dir}${fact_file_name}.yaml": ensure => absent }
    }#absent

    default: {}
  }#case

}
