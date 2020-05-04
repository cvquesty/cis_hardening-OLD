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



}
