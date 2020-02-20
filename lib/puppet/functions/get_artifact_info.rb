#
require 'artifactory'

include Artifactory::Resource

Puppet::Functions.create_function(:get_artifact_info) do
  dispatch :get_artifact_info do
    param 'String', :group_id
    param 'String', :artifact_id
    param 'String', :version
    param 'String', :repository
    param 'String', :extension
    return_type 'Hash'
  end

  def get_artifact_info(group_id, artifact_id, version, repository, extension)
    latest = Artifact.latest_version(
      group:      group_id,
      name:       artifact_id,
      version:    version,
      repos:      repository,
    )

    classifier = if latest.to_s == ''
                   "#{version}.#{extension}"
                 else
                   "#{latest}.#{extension}"
                 end

    artifacts = Artifact.gavc_search(
      group:      group_id,
      name:       artifact_id,
      classifier: classifier,
      repos:      repository,
    )

    return_value = {}
    return_value['filename'] = artifacts.first.download_uri.split('/').last
    return_value['download_uri'] = artifacts.first.download_uri

    return_value
  end
end
