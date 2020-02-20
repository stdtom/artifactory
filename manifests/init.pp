# Class: artifactory
#
# This module downloads Artifacts from Artifactory
#
# @param endpoint
#   The endpoint for the Artifactory server. If you are running the "default"
#   Artifactory installation using tomcat, don't forget to include the
#   +/artifactoy+ part of the URL.
#
# @param username
#   The username used to authenticate to the Artifactory server.
#
# @param password
#   The password used to authenticate to the Artifactory server.
#   Since this uses HTTP Basic Auth, it is highly recommended that you run Artifactory over SSL.
#
# @param api_key
#   The API key used to authenticate to the Artifactory server.
#   You can also use an API key for authentication. 
#   username and password take precedence so leave them off if you are using an API key.
#
class artifactory (
  Stdlib::HTTPUrl $endpoint,
  Optional[String] $username,
  Optional[String] $password,
  Optional[String] $api_key,
) {
  if ($endpoint == undef) or ($endpoint == '') {
    fail('Cannot initialize the Artifactory class - the endpoint parameter is mandatory')
  }

  if ($api_key == undef) or ($api_key == '') {
    # API key is not set

    if ($username != undef) and ($username != '')
            and (($password == undef) or ($password == '')) {
      fail('Cannot initialize the Artifactory class - either both, username and password, must be set or non of them')
    } elsif ($password != undef) and ($password != '')
            and (($username == undef) or ($username == '')) {
      fail('Cannot initialize the Artifactory class - either both, username and password, must be set or non of them')
    } else {
      if ($username == undef) {
        config_endpoint($endpoint)
      } else {
        config_endpoint($endpoint, $username, $password)
      }
    }
  } else {
    # API key is set

    if (($username != undef) and ($username != ''))
            or (($password != undef) and ($password != '')) {
      fail('Using api_key and username/password - username/password will take precedence')
    } else {
      config_endpoint($endpoint, $api_key)
    }
  }

}
