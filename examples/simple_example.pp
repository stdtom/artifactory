node default {
  class { artifactory :
    endpoint => 'https://repo.jfrog.org/artifactory',
    #username => 'user',
    #password => 'password',
    #api_key  => 'xxxxxxxxxxxxxxx',
  }

  artifactory::artifact {'artifactory-api':
    group_id   => 'org.artifactory',
    version    => '',
    repository => 'oss-releases-local',
    output     => '/tmp/',
    extension  => 'jar',
  }
}

