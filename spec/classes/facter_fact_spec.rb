require 'spec_helper'

describe 'facter::fact', :type => 'define' do
  let(:pre_condition) { ['include facter'] }
  let(:title) { 'facter_spec_test' }
  let(:params) { {'ensure' => 'present', 'value' => 'test_value'} }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      case os_facts[:kernel]
      when 'Linux'
        it { is_expected.to contain_file('/etc/puppetlabs/facter/facts.d/facter_spec_test.yaml').with('ensure' => 'present', 'content' => "facter_spec_test: test_value\n") }
      when 'windows'
        it { is_expected.to contain_file('C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\facter_spec_test.yaml').with('ensure' => 'present', 'content' => "facter_spec_test: test_value\n") }
      end#case
    end#context
  end#each
end#describe
