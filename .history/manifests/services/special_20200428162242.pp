# @summary A manifest to configure special services according to 
# CIS Hardening Guidelines
#
# Section 2.2
#
# @example
#   include cis_hardening::services::special
class cis_hardening::services::special {

  # Ensure time synchronization is in use - Section 2.2.1.1
  package { 'ntp':
    ensure => 'present',
  }

  package{ 'chrony':
    ensure => 'present',
  }

  # Ensure ntp is configured - Section 2.2.1.2
  file { '/etc/ntp.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/cis_hardening/ntp_conf',
    require => Package['ntp'],
  }

  file { '/etc/sysconfig/ntpd':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/cis_hardening/etc_sysconfig_ntpd',
    require => File['/etc/ntp.conf'],
  }

  file_line { 'ntp_options':
    ensure => 'present',
    path   => '/usr/lib/systemd/system/ntpd.service',
    line   => 'ExecStart=/usr/sbin/ntpd -u ntp:ntp $OPTIONS',
    match  => '^ExecStart=/usr/sbin/ntpd -u ntp:ntp $OPTIONS',
  }

  # Ensure Chrony is configured - Section 2.2.1.3
  file { '/etc/chrony.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cis_hardening/etc_chrony_conf',
  }

  file_line { 'chrony_settings':
    ensure => 'present',
    path   => '/etc/sysconfig/chronyd',
    line   => 'OPTIONS="-u chrony"',
    match  => '^OPTIONS="-u"',
  }

  # Ensure X Window System is not installed
  package { 'xorg-x11':
    ensure => 'absent',
  }

}
