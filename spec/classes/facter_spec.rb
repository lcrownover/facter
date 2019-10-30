require 'spec_helper'

describe 'facter' do

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      case os_facts[:kernel]
      when 'Linux'
        it { is_expected.to contain_file('/etc/puppetlabs/facter/facts.d/') }
      when 'windows'
        it { is_expected.to contain_file('C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\') }
      end#case

    end#context

  end#each

end#describe
