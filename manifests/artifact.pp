# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   artifactory::artifact { 'namevar': }
define artifactory::artifact (
  String $output,
  String $group_id,
  String $artifact_id           = $title,
  Optional[String] $version     = '',
  Optional[String] $repository  = '',
  Optional[String] $extension   = 'jar',
  Optional[String] $classifier  = undef,
  String $ensure                = present,
  Optional[String] $owner       = undef,
  Optional[String] $group       = undef,
  Optional[String] $mode        = undef,
) {
  $artifact = get_artifact_info($group_id, $artifact_id, $version, $repository, $extension)

  if $output =~ /\/$/ {
    $target_file = "${output}${artifact[filename]}"
  } else {
    $target_file = $output
  }

  if ($artifactory::api_key) {
    $auth = "-H \"X-JFrog-Art-Api:${artifactory::api_key}\""
  } elsif ($artifactory::username and $artifactory::password) {
    $auth = "-u \"${artifactory::username}:${artifactory::password}\""
  } else {
    $auth = ''
  }

  $cmd = $facts['os']['family'] ? {
    /(W|w)indows/   => "h:/curl.exe -k ${auth} \"${$artifact[download_uri]}\"  -o ${target_file}",
    default         => "curl -k  \"${$artifact[download_uri]}\"  -o ${target_file} -K- <<< \"${auth}\"",
  }

  $path = $facts['os']['family'] ? {
    /(W|w)indows/   => undef,
    default         => '/usr/bin:/bin:/usr/local/bin:/opt/local/bin',
  }

  if $ensure == present {
    exec { "Download ${name}":
      command => $cmd,
      path    => $path,
      creates => $target_file,
    }
  } elsif $ensure == update {
    exec { "Download ${name}":
      command => $cmd,
      path    => $path,
    }
  }

  if $ensure != absent {
    file { $target_file:
      ensure  => file,
      require => Exec["Download ${name}"],
      owner   => $owner,
      group   => $group,
      mode    => $mode,
    }
  } else {
    file { "Remove ${name}":
      ensure => absent,
      path   => $target_file,
    }
  }
}
