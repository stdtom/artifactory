require 'spec_helper'

describe 'artifactory' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { 'endpoint' => 'https://repo.jfrog.org/artifactory' } }

      it { is_expected.to compile }
    end
  end

  describe 'with endpoint' do
    context 'is a valid http url' do
      params = [
        'http://my.artifactory.net',
        'https://my.artifactory.net',
        'https://my.artifactory.net:8080',
        'https://my.artifactory.net/artifactory',
        'https://my.artifactory.net:8080/artifactory',
      ]

      params.each do |p|
        let(:params) { { 'endpoint' => p } }

        it { is_expected.to compile }
      end
    end

    context 'is not a valid http url' do
      params = [
        # 'my.artifactory.net',
        # 'https://my.artifactory.net:xx',
        # 'https://my.artifactory.net/ar tifactory',
        # 'https://my.arti factory.net:8080/artifactory',
      ]

      params.each do |p|
        let(:params) { { 'endpoint' => p } }

        it { is_expected.not_to compile }
      end
    end
  end

  describe 'with login credentials' do
    context 'when username and password are set' do
      let(:params) do
        {
          endpoint: 'https://repo.jfrog.org/artifactory',
          username: 'myuser',
          password: 'secret_password',
          api_key:  :undef,
        }
      end

      it { is_expected.to compile }
    end

    context 'when username is set but password is not set' do
      let(:params) do
        {
          endpoint: 'https://repo.jfrog.org/artifactory',
          username: 'myuser',
          password: :undef,
          api_key:  :undef,
        }
      end

      it { is_expected.not_to compile }
    end

    context 'when password is set but username is not set' do
      let(:params) do
        {
          endpoint: 'https://repo.jfrog.org/artifactory',
          username: :undef,
          password: 'secret_password',
          api_key:  :undef,
        }
      end

      it { is_expected.not_to compile }
    end

    context 'when username and password are not set' do
      let(:params) do
        {
          endpoint: 'https://repo.jfrog.org/artifactory',
          username: :undef,
          password: :undef,
          api_key:  :undef,
        }
      end

      it { is_expected.to compile }
    end
  end

  describe 'with api_key' do
    context 'when username and password are set' do
      let(:params) do
        {
          endpoint: 'https://repo.jfrog.org/artifactory',
          username: 'myuser',
          password: 'secret_password',
          api_key:  'xxxxxxxxxxxxx',
        }
      end

      it { is_expected.not_to compile }
      # it { is_expected.to compile.and_raise_error(/Using api_key and username/) }
    end

    context 'when username and password are not set' do
      let(:params) do
        {
          endpoint: 'https://repo.jfrog.org/artifactory',
          username: :undef,
          password: :undef,
          api_key:  'xxxxxxxxxxxxx',
        }
      end

      it { is_expected.to compile }
    end
  end
end
