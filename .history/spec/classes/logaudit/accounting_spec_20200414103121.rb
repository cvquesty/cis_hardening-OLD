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

      # Ensure that Ensure audit log storage size is configured - Section 4.1.1.1
      it { is_expected.to contain_exec('set_auditd_logfile_size').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^max_log_file.*$/max_log_file = 1024' /etc/audit/auditd.conf",
        'onlyif'  => "grep '^max_log_file' /etc/audit/auditd.conf",
        'notify'  => Exec['restart_auditd'],
      )}

      # Ensure that system is disabled when audit logs are full - Section 4.1.1.2
      it { is_expected.to contain_exec('full_logfile_notify_action').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^space_left_action.*$/space_left_action = email/' /etc/audit/auditd.conf",
        'onlyif'  => "grep '^^space_left_action' /etc/audit/auditd.conf",
        'notify'  => Exec['restart_auditd'],
      )}

      it { is_expected.to contain_exec('set_action_mail_account').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^action_mail_acct.*$/action_mail_acct = root' /etc/audit/auditd.conf",
        'onlyif'  => "grep '^mail_action_acct' /etc/audit/auditd.conf",
        'notify'  => Exec['restart_auditd'],
      )}

      it { is_expected.to contain_exec('set_admin_space_left_action').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^admin_space_left_action.*$/admin_space_left_action = SYSLOG/' /etc/audit/auditd.conf",
        'onlyif'  => "grep '^admin_space_left_action' /etc/audit/auditd.conf",
        'notify'  => Exec['restart_auditd'],
      )}

      # Ensure that Ensure audit logs are not automatically deleted - Section 4.1.1.3
      it { is_expected.to contain_exec('set_max_logfile_action').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^max_log_file_action.*$/max_log_file_action = keep_logs' /etc/audit/auditd.conf",
        'onlyif'  => "grep '^max_log_file_action' /etc/audit/auditd.conf",
      )}

      # Ensure that Ensure auditd service is enabled - Section 4.1.2
      it { is_expected.to contain_service('auditd').with(
        'ensure'     => 'running',
        'enable'     => true,
        'hasstatus'  => true,
        'hasrestart' => true,
      )}

      # Ensure that Ensure defaults directory is present for grub settings - Section 4.1.3 prerequisites
      it { is_expected.to contain_file('/etc/default').with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      )}

      it { is_expected.to contain_file('/etc/default/grub').with(
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => File['/etc/default'],
      )}

      # Ensure that 

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
