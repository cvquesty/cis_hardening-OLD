require 'spec_helper'

describe 'cis_hardening::logaudit::accounting' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::logaudit::accounting')}

      # Ensure that Exec to notify from auditd rules changes - Section 4.1.1
      it { is_expected.to contain_exec('restart_auditd').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => '/bin/systemctl restart auditd',
      )}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
