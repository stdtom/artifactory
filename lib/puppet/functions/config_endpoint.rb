#
require 'artifactory'

# @summary
#   Initializes the Artifactory Client with the given parameters
#
Puppet::Functions.create_function(:config_endpoint) do
  # @param endpoint
  #   The endpoint for the Artifactory server. If you are running the "default"
  #   Artifactory installation using tomcat, don't forget to include the
  #   +/artifactoy+ part of the URL.
  #
  # @param api_key
  #   The API key used to authenticate to the Artifactory server.
  #   You can also use an API key for authentication.
  #   username and password take precedence so leave them off if you are using an API key.
  #
  dispatch :config_api_key do
    param 'String', :endpoint
    param 'String', :api_key
  end

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
  dispatch :config_user_pw do
    param 'String', :endpoint
    param 'String', :username
    param 'String', :password
  end

  # @param endpoint
  #   The endpoint for the Artifactory server. If you are running the "default"
  #   Artifactory installation using tomcat, don't forget to include the
  #   +/artifactoy+ part of the URL.
  #
  dispatch :config_without_credentials do
    param 'String', :endpoint
  end

  def config_api_key(endpoint, api_key)
    Artifactory.endpoint = endpoint
    Artifactory.username = nil
    Artifactory.password = nil
    Artifactory.api_key = api_key

    detect_proxy
  end

  def config_user_pw(endpoint, username, password)
    Artifactory.endpoint = endpoint
    Artifactory.username = username
    Artifactory.password = password
    Artifactory.api_key = nil

    detect_proxy
  end

  def config_without_credentials(endpoint)
    Artifactory.endpoint = endpoint
    Artifactory.username = nil
    Artifactory.password = nil
    Artifactory.api_key = nil

    detect_proxy
  end

  def detect_proxy
    proxy_url = if ENV['http_proxy']
                  ENV['http_proxy']
                elsif ENV['https_proxy']
                  ENV['https_proxy']
                else
                  nil
                end

    return unless proxy_url

    components = proxy_url.gsub('http://', '').gsub('https://', '').split(':')

    Artifactory.proxy_address  = components.first
    Artifactory.proxy_port     = components.last
  end
end
