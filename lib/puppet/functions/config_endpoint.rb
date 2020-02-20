#
require 'artifactory'

Puppet::Functions.create_function(:config_endpoint) do
  dispatch :config_api_key do
    param 'String', :endpoint
    param 'String', :api_key
  end

  dispatch :config_user_pw do
    param 'String', :endpoint
    param 'String', :username
    param 'String', :password
  end

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
    proxy_url = if ENV['xhttp_proxy']
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
