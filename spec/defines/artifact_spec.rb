require 'spec_helper'

describe 'artifactory::artifact' do
  let(:title) { 'namevar' }
  let(:pre_condition) { "class { artifactory : endpoint => 'https://repo.jfrog.org/artifactory' }" }

  let(:params) do
    {
      group_id: 'org.artifactory',
      artifact_id: 'artifactory-api',
      repository: 'oss-releases-local',
      output: '/tmp/',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
