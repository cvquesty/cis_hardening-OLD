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
      ).that_notifies('Exec[restart_auditd]')}

      # Ensure that system is disabled when audit logs are full - Section 4.1.1.2
      it { is_expected.to contain_exec('full_logfile_notify_action').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^space_left_action.*$/space_left_action = email/' /etc/audit/auditd.conf",
        'onlyif'  => "grep '^^space_left_action' /etc/audit/auditd.conf",
      ).that_notifies('Exec[restart_auditd]')}

      it { is_expected.to contain_exec('set_action_mail_account').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^action_mail_acct.*$/action_mail_acct = root' /etc/audit/auditd.conf",
        'onlyif'  => "grep '^mail_action_acct' /etc/audit/auditd.conf",
      ).that_notifies('Exec[restart_auditd]')}

      it { is_expected.to contain_exec('set_admin_space_left_action').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^admin_space_left_action.*$/admin_space_left_action = SYSLOG/' /etc/audit/auditd.conf",
        'onlyif'  => "grep '^admin_space_left_action' /etc/audit/auditd.conf",
      ).that_notifies('Exec[restart_auditd]')}

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
      ).that_requires('File[/etc/default]')}

      # Ensure that Ensure auditing for processes that start prior to auditd is enabled - Section 4.1.3
      it { is_expected.to contain_file_line('pre_auditd_settings').with(
        'ensure'  => 'present',
        'path'    => '/etc/default/grub',
        'line'    => 'GRUB_CMDLINE_LINUX="audit=1"',
        'match'   => '^GRUB_CMDLINE_LINUX=',
      ).that_requires('File[/etc/default/grub]')}

      # Ensure that Ensure events that modify date and time information are collected - Section 4.1.4
      it { is_expected.to contain_file_line('time_change_64bit_item1').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change',
      )}

      it { is_expected.to contain_file_line('time_change_64bit_item2').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-a always,exit -F arch=b64 -S clock_settime -k time-change',
      )}

      it { is_expected.to contain_file_line('time_change_64bit_item3').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-w /etc/localtime -p wa -k time-change',
      )}

      # Ensure that Ensure events that modify user/group information are collected - Section 4.1.5
      it { is_expected.to contain_file_line('ownerchange_group').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-w /etc/group -p wa -k identity',
      )}

      it { is_expected.to contain_file_line('ownerchange_passwd').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-w /etc/passwd -p wa -k identity',
      )}

      it { is_expected.to contain_file_line('ownerchange_gshadow').with(
        'ensure' => 'present',
        'path'   => '/etc/audot/audit.rules',
        'line'   => '-w /etc/gshadow -p wa -k identity',
      )}

      it { is_expected.to contain_file_line('ownerchange_shadow').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-w /etc/shadow -p wa -k identity',
      )}

      it { is_expected.to contain_file_line('ownerchange_opasswd').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-w /etc/security/opasswd -p wa -k identity',
      )}

      # Ensure that Ensure events that modify the system's network environment are collected - Section 4.1.6
      it { is_expected.to contain_file_line('network_namechanges').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale',
      )}

      it { is_expected.to contain_file_line('network_issue').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-w /etc/issue -p wa -k system-locale',
      )}

      it { is_expected.to contain_file_line('network_issuedotnet').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-w /etc/issue.net -p wa -k system-locale',
      )}

      it { is_expected.to contain_file_line('network_network').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-w /etc/sysconfig/network -p wa -k system-locale',
      )}

      it { is_expected.to contain_file_line('network_networkscripts').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-w /etc/sysconfig/network-scripts/ -p wa -k system-locale',
      )}

      # Ensure that Ensure events that modify the system's Mandatory Access Controls are collected - Section 4.1.7
      it { is_expected.to contain_file_line('macpolicy_selinux').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-w /etc/selinux/ -p wa -k MAC-policy',
      )}

      it { is_expected.to contain_file_line('macpolicy_selinuxshare').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-w /usr/share/selinux/ -p wa -k MAC-policy',
      )}

      # Ensure that Ensure login and logout events are collected - Section 4.1.8
      it { is_expected.to contain_file_line('lastlogin').with(
        'ensure' => 'present',
        'path'   => '/etc/audit/audit.rules',
        'line'   => '-w /var/log/lastlog -p wa -k logins',
      )}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
