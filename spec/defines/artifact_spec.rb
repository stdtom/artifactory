require 'spec_helper'

describe 'artifactory::artifact' do
  let(:title) { 'namevar' }
  let(:pre_condition) { "class { artifactory : endpoint => 'https://repo.jfrog.org/artifactory' }" }

  describe 'with exisiting artifact_id' do
    let(:params) do
      {
        group_id: 'org.artifactory',
        artifact_id: 'artifactory-api',
        repository: 'oss-releases-local',
        output: '/tmp/',
      }
    end

    context 'when no version is set' do
      let(:params) do
        super().merge(version: '')
      end

      on_supported_os.each do |os, os_facts|
        context "on #{os}" do
          let(:facts) { os_facts }

          it { is_expected.to compile }
        end
      end
    end

    context 'when version exists' do
      let(:params) do
        super().merge(version: '7.6.3')
      end

      on_supported_os.each do |os, os_facts|
        context "on #{os}" do
          let(:facts) { os_facts }

          it { is_expected.to compile }
        end
      end
    end

    context 'when version=latest' do
      let(:params) do
        super().merge(version: 'latest')
      end

      on_supported_os.each do |os, os_facts|
        context "on #{os}" do
          let(:facts) { os_facts }

          it { is_expected.to compile }
        end
      end
    end
  end
end
