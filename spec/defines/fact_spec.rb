require 'spec_helper'

describe 'facter::fact', type: 'define' do
  let(:pre_condition) { ['include facter'] }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'with array' do
        let(:title) { 'facter_spec_test' }
        let(:params) { { 'ensure' => 'present', 'value' => ['a', 'b'] } }

        it { is_expected.to compile }
        case os_facts[:kernel]
        when 'Linux'
          fact_path = '/etc/puppetlabs/facter/facts.d/facter_spec_test.yaml'
        when 'windows'
          fact_path = 'C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\facter_spec_test.yaml'
        end # case

        it {
          is_expected.to contain_file(fact_path)
            .with('ensure' => 'present')
            .with('content' => "---\nfacter_spec_test:\n- a\n- b\n")
        }
      end # describe array

      describe 'with hash' do
        let(:title) { 'facter_spec_test' }
        let(:params) { { 'ensure' => 'present', 'value' => { a: 'b' } } }

        it { is_expected.to compile }
        case os_facts[:kernel]
        when 'Linux'
          fact_path = '/etc/puppetlabs/facter/facts.d/facter_spec_test.yaml'
        when 'windows'
          fact_path = 'C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\facter_spec_test.yaml'
        end # case

        it {
          is_expected.to contain_file(fact_path)
            .with('ensure' => 'present')
            .with('content' => "---\nfacter_spec_test:\n  a: b\n")
        }
      end # describe hash

      describe 'with simple string' do
        let(:title) { 'facter_spec_test' }
        let(:params) { { 'ensure' => 'present', 'value' => 'abc' } }

        it { is_expected.to compile }
        case os_facts[:kernel]
        when 'Linux'
          fact_path = '/etc/puppetlabs/facter/facts.d/facter_spec_test.yaml'
        when 'windows'
          fact_path = 'C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\facter_spec_test.yaml'
        end # case

        it {
          is_expected.to contain_file(fact_path)
            .with('ensure' => 'present')
            .with('content' => "---\nfacter_spec_test: abc\n")
        }
      end # describe simple string

      describe 'with messy string' do
        let(:title) { 'facter_spec_test' }
        let(:params) { { 'ensure' => 'present', 'value' => "abc\n123 - you & me" } }

        it { is_expected.to compile }
        case os_facts[:kernel]
        when 'Linux'
          fact_path = '/etc/puppetlabs/facter/facts.d/facter_spec_test.yaml'
        when 'windows'
          fact_path = 'C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\facter_spec_test.yaml'
        end # case

        it {
          is_expected.to contain_file(fact_path)
            .with('ensure' => 'present')
            .with('content' => "---\nfacter_spec_test: |-\n  abc\n  123 - you & me\n")
        }
      end # describe messy string

      describe 'with boolean' do
        let(:title) { 'facter_spec_test' }
        let(:params) { { 'ensure' => 'present', 'value' => true } }

        it { is_expected.to compile }
        case os_facts[:kernel]
        when 'Linux'
          fact_path = '/etc/puppetlabs/facter/facts.d/facter_spec_test.yaml'
        when 'windows'
          fact_path = 'C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\facter_spec_test.yaml'
        end # case

        it {
          is_expected.to contain_file(fact_path)
            .with('ensure' => 'present')
            .with('content' => "---\nfacter_spec_test: true\n")
        }
      end # describe bool string

      describe 'with integer' do
        let(:title) { 'facter_spec_test' }
        let(:params) { { 'ensure' => 'present', 'value' => 321 } }

        it { is_expected.to compile }
        case os_facts[:kernel]
        when 'Linux'
          fact_path = '/etc/puppetlabs/facter/facts.d/facter_spec_test.yaml'
        when 'windows'
          fact_path = 'C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\facter_spec_test.yaml'
        end # case

        it {
          is_expected.to contain_file(fact_path)
            .with('ensure' => 'present')
            .with('content' => "---\nfacter_spec_test: 321\n")
        }
      end # describe int

      describe 'with float' do
        let(:title) { 'facter_spec_test' }
        let(:params) { { 'ensure' => 'present', 'value' => 3.1415 } }

        it { is_expected.to compile }
        case os_facts[:kernel]
        when 'Linux'
          fact_path = '/etc/puppetlabs/facter/facts.d/facter_spec_test.yaml'
        when 'windows'
          fact_path = 'C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\facter_spec_test.yaml'
        end # case

        it {
          is_expected.to contain_file(fact_path)
            .with('ensure' => 'present')
            .with('content' => "---\nfacter_spec_test: 3.1415\n")
        }
      end # describe float

      describe 'with undef' do
        let(:title) { 'facter_spec_test' }
        let(:params) { { 'ensure' => 'present', 'value' => :undef } }

        it { is_expected.to compile }
        case os_facts[:kernel]
        when 'Linux'
          fact_path = '/etc/puppetlabs/facter/facts.d/facter_spec_test.yaml'
        when 'windows'
          fact_path = 'C:\\ProgramData\\PuppetLabs\\facter\\facts.d\\facter_spec_test.yaml'
        end # case

        it {
          is_expected.to contain_file(fact_path)
            .with('ensure' => 'present')
            .with('content' => "---\nfacter_spec_test: \n")
        }
      end # describe undef
    end # context
  end # each
end # describe
