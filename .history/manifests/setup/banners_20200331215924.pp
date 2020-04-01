# @summary A manifest to configure system warning banners according to policy in line with CIS hardening
# guidelines
#
# Section 1.7
#
# @example
#   include cis_hardening::setup::banners
class cis_hardening::setup::banners {

  # 1.7 - Command Line Warning Banners

  # Ensure message of the day (MOTD) is properly configured - Section 1.7.1.1
  file { '/etc/motd':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cis_hardening/etc_motd',
  }

  # Ensure local login warning banner is configured properly - Section 1.7.1.2
  file { '/etc/issue':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cis_hardening/etc_issue',
  }

}
