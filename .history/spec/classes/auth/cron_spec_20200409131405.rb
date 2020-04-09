require 'spec_helper'

describe 'cis_hardening::auth::cron' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::auth::cron')}

      # Check that Enable Cron Daemon - Section 5.1.1 is correct
      it { is_expected.to contain_service('cron').with(
        'ensure'     => 'running',
        'hasstatus'  => true,
        'hasrestart' => true,
        'enable'     => true,
      )}

      # Check that Ensure permissions on /etc/crontab are configured - Section 5.1.2 is correct
      it { is_expected.to contain_file('/etc/crontab').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      )}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
