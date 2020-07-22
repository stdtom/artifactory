# @summary This defined type allows to specify an artifact that should be searched in and downloaded from artifactory.
#
#
# @example
#   artifactory::artifact {'myartifact':
#     group_id    => 'org.artifactory',
#     artifact_id => 'artifactory-api',
#     version     => '',
#     repository  => 'oss-releases-local',
#     output      => "/tmp/",
#     extension   => 'jar',
#   }
#
# @param output
#   The target file name or folder to store the artifact in.
#
# @param group_id
#   the Maven group id to search for
#
# @param artifact_id
#   the Maven artifact id to search for
#
# @param version
#   the Maven version of the artifact to search for
#
# @param repository
#   the list of repos to search
#
# @param extension
#   the file extension to search
#
# @param classifier
#   the classifer to search for
#
# @param ensure
#   Whether of the artifact should exist at the target location or not and weather it should be updated.
#
# @param owner
#   The user which should own the artifact file. Argument can be a user name or a user ID.
#   This value will be passed to the owner attribute of a Puppet file resource.
#
# @param group
#   The group which should own the artifact file. Argument can be either a group name or a group ID.
#   This value will be passed to the group attribute of a Puppet file resource.
#
# @param mode
#   The desired permissions mode for the artifact file, in symbolic or numeric notation.
#   This value will be passed to the mode attribute of a Puppet file resource.
#
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

  if !is_hash($artifact) or (!( 'filename' in $artifact)) or (!( 'download_uri' in $artifact))  {
    err("Could not find version '${version}' of artifact '${artifact_id}'.")
  } else {

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
}
