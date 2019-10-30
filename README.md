# facter

Provides a simple way to manage external facts



## Setup

All you need to do is include the module:

```puppet
include facter
```

It will automatically create the ```facts.d``` path:

- Linux:
  ```
  /etc/puppetlabs/facter/facts.d
  ```

- Windows:
  ```
  C:\ProgramData\PuppetLabs\facter\facts.d\
  ```



## Usage

This module creates yaml files in the ```facts.d``` directory with the resource name as the file name and content following the external fact convention for yaml:

```
resource_name: value
```

You can use the ```facter::fact``` defined type in the manifest, or use ```facter::fact_hash:``` in hiera to set and remove facts


### Examples

Set a fact in a puppet manifest

```puppet
facter::fact { 'datacenter':
  value => 'us_west',
}
```

Remove a fact you previously set

```puppet
facter::fact { 'datacenter':
  ensure => absent,
}
```

Set a fact with a custom filename

```puppet
facter::fact { 'datacenter':
  file_name => 'my_datacenter',
  value     => 'us_west',
}
```

Set one or multiple facts using hiera

```puppet
facter::fact_hash:
  datacenter: 'us_west'
  cluster: 'web'
```

Remove facts using hiera

```puppet
facter::fact_hash:
  datacenter: 'us_west'
  cluster:
    ensure => 'absent'
```

Or the shorter version to remove a fact, making use of the reserved ```absent``` value:

```puppet
facter::fact_hash:
  datacenter: 'us_west'
  cluster: 'absent'
```





## Parameters

### facter

- ```disable_reserved_absent```

  *optional[Boolean]:* Disables the reserved word *'absent'* for hiera facts. The only reason to disable this would be if you wanted the ability to set the value of facts to the string *'absent'*.

  *default:* ```false```


### facter::fact

- ```ensure```

  *optional[String]:* Determines if the resource is created or removed.

  *default:* ```'present'```


- ```value```  
  *required[String]:* Value of the fact to be set.

  *warning:* ```absent``` *is a reserved word for value in the hiera implementation and will remove the fact*


- ```file_name```  

  *optional[String]:* Set the target file name instead of using the resource name as the file name.
  
  *default:* ```$title```