require 'spec_helper'

describe 'cis_hardening::logaudit::logging' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      
      # Check for default class
      it { is_expected.to contain_class('cis_hardening::logaudit::logging')}

      # Ensure that Ensure rsyslog service is enabled - Section 4.2.1.1
      it { is_expected.to contain_service('rsyslog').with(
        'ensure'     => 'running',
        'enable'     => true,
        'hasstatus'  => true,
        'hasrestart' => true,
      ).that_requires('Package[rsyslog]')}


      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
