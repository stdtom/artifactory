# artifactory


#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with artifactory](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with artifactory](#beginning-with-artifactory)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

Artifactory is a universal artifact repository manager which can store software artifacts which are developed in various
languages and technologies.

This module allows to search artifacts in an Artifactory instance via the Artifactory API and to download them to the managed node.

## Setup


### Setup Requirements

Manually install this module with Puppet module tool:

``` console
$ puppet module install stdtom-artifactory
``` 

The module relies on the [Ruby client for Artifactory](https://github.com/chef/artifactory-client) developed by Chef Software, Inc.
Therefore the RubyGem `artifactory` has to be installed.


To install RubyGem `artifactory` execute on Puppet Server:

``` console
$ /opt/puppetlabs/bin/puppetserver gem install artifactory -v 2.8.2
$ systemctl restart puppetserver
``` 

If you are running Puppet in a masterless environment, execute on the managed server:

``` console
$ /opt/puppetlabs/puppet/bin/gem install artifactory -v 2.8.2
``` 





### Beginning with artifactory

To initialize Puppet for using the Artifactory client, declare the `artifactory` class:

``` puppet
class { artifactory :
  endpoint => 'https://repo.jfrog.org/artifactory',
}
```

If you are running the "default" Artifactory installation using tomcat, don't forget to include the
+/artifactoy+ part of the URL in the `endpoint` parameter.



## Usage

### Artifactory authentication

In case your Artifactory server requires authentication, you can also initialize the [`artifactory`][] class with 
basic authentication information. Since this uses HTTP Basic Auth, it is highly recommended that you run Artifactory over SSL.

``` puppet
class { artifactory :
  endpoint => 'https://repo.jfrog.org/artifactory',
  username => 'myuserid',
  password => 'secretpassword',
}
```


You can also use an API key for authentication. Username and password take precedence so leave them off if you are using an API key.


``` puppet
class { artifactory :
  endpoint => 'https://repo.jfrog.org/artifactory',
  api_key  => 'xxxxxxxxxxxxxxx',
}
```

### Serach an artifact

``` puppet
artifactory::artifact {'myartifact':
  group_id    => 'org.artifactory',
  artifact_id => 'artifactory-api',
  version     => '',
  repository  => 'oss-releases-local',
  output      => "/tmp/",
  extension   => 'jar',
}
```


## Reference

see (REFERENCE.md)

## Limitations

For an extensive list of supported operating systems, see (metadata.json)

## Development

In the Development section, tell other users the ground rules for contributing to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header.
