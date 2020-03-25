# @summary A manifest to configure system accounting according to
# CIS hardening Guidelines
#
# Configure System Accounting - Section 4.1
#
# @example
#   include cis_hardening::logaudit::accounting
class cis_hardening::logaudit::accounting {

  # Exec to notify from auditd rules changes - Section 4.1.1
  exec { 'restart_auditd':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => '/bin/systemctl restart auditd',
  }


  # Ensure audit log storage size is configured - Section 4.1.1.1
  exec { 'set_auditd_logfile_size':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^max_log_file.*$/max_log_file = 1024' /etc/audit/auditd.conf",
    onlyif  => "grep '^max_log_file' /etc/audit/auditd.conf",
    notify  => Exec['restart_auditd'],
  }

  # Ensure system is disabled when audit logs are full - Section 4.1.1.2
  #
  # Acceptable risk. The servers cannot be shut down in production due to a 
  # lack of logging. Instead, the below will alert SysLog that logging is not
  # occurring, and an alert should be set for the related condition, that is, 
  # that logs are no longer being produced. One would also argue that disk space
  # alerts would also notify operational personnel of the condition

  exec { 'full_logfile_notify_action':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^space_left_action.*$/space_left_action = email/' /etc/audit/auditd.conf",
    onlyif  => "grep '^^space_left_action' /etc/audit/auditd.conf",
    notify  => Exec['restart_auditd'],
  }

  exec { 'set_action_mail_account':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^action_mail_acct.*$/action_mail_acct = root' /etc/audit/auditd.conf",
    onlyif  => "grep '^mail_action_acct' /etc/audit/auditd.conf",
    notify  => Exec['restart_auditd'],
  }

  exec { 'set_admin_space_left_action':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^admin_space_left_action.*$/admin_space_left_action = SYSLOG/' /etc/audit/auditd.conf",
    onlyif  => "grep '^admin_space_left_action' /etc/audit/auditd.conf",
    notify  => Exec['restart_auditd'],
  }

  # Ensure audit logs are not automatically deleted - Section 4.1.1.3
  exec { 'set_max_logfile_action':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^max_log_file_action.*$/max_log_file_action = keep_logs' /etc/audit/auditd.conf",
    onlyif  => "grep '^max_log_file_action' /etc/audit/auditd.conf",
  }

  # Ensure auditd service is enabled - Section 4.1.2
  service { 'auditd':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  # Ensure defaults directory is present for grub settings - Section 4.1.3 prerequisites
  file { '/etc/default':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/default/grub':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/default'],
  }

  # Ensure auditing for processes that start prior to auditd is enabled - Section 4.1.3
  file_line { 'pre_auditd_settings':
    ensure  => 'present',
    path    => '/etc/default/grub',
    line    => 'GRUB_CMDLINE_LINUX="audit=1"',
    match   => '^GRUB_CMDLINE_LINUX=',
    require => File['/etc/default/grub'],
  }

  # Ensure events that modify date and time information are collected - Section 4.1.4
  file_line { 'time_change_64bit_item1':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change',
  }

  file_line { 'time_change_64bit_item2':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-a always,exit -F arch=b64 -S clock_settime -k time-change',
  }

  file_line { 'time_change_64bit_item3':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/localtime -p wa -k time-change',
  }

  # Ensure events that modify user/group information are collected - Section 4.1.5
  file_line { 'ownerchange_group':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/group -p wa -k identity',
  }

  file_line { 'ownerchange_passwd':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/passwd -p wa -k identity',
  }

  file_line { 'ownerchange_gshadow':
    ensure => 'present',
    path   => '/etc/audot/audit.rules',
    line   => '-w /etc/gshadow -p wa -k identity',
  }

  file_line { 'ownerchange_shadow':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/shadow -p wa -k identity',
  }

  file_line { 'ownerchange_opasswd':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/security/opasswd -p wa -k identity',
  }

  # NOTE: Above audit.rules settings may require a reboot to become effective especially in regards
  # to those rules to be activated prior to Grub's loading

  # Ensure events that modify the system's network environment are collected - Section 4.1.6
  file_line { 'network_namechanges':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale',
  }

  file_line { 'network_issue':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/issue -p wa -k system-locale',
  }

  file_line { 'network_issuedotnet':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/issue.net -p wa -k system-locale',
  }

  file_line { 'network_network':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/sysconfig/network -p wa -k system-locale',
  }

  file_line { 'network_networkscripts':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/sysconfig/network-scripts/ -p wa -k system-locale',
  }

  # Ensure events that modify the system's Mandatory Access Controls are collected - Section 4.1.7
  file_line { 'macpolicy_selinux':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/selinux/ -p wa -k MAC-policy',
  }

  file_line { 'macpolicy_selinuxshare':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /usr/share/selinux/ -p wa -k MAC-policy',
  }

  # Ensure login and logout events are collected - Section 4.1.8
  file_line { 'lastlogin':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /var/log/lastlog -p wa -k logins',
  }

  file_line { 'faillock':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /var/run/faillock/ -p wa -k logins',
  }

}
