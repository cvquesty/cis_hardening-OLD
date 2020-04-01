# @summary A manifest to configure system warning banners according to policy in line with CIS hardening
# guidelines
#
# Section 1.7
#
# @example
#   include cis_hardening::setup::banners
class cis_hardening::setup::banners {

  # 1.7 - Command Line Warning Banners

  # Ensure message of the day (MOTD) is properly configured - Section 1.7.1.1,
  # Ensure permisisons on /etc/motd are configured - Section 1.7.1.4
  file { '/etc/motd':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cis_hardening/etc_motd',
  }

  # Ensure local login warning banner is configured properly - Section 1.7.1.2
  # Ensure permissions on /etc/issue are configured - Section 1.7.1.5
  file { '/etc/issue':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cis_hardening/etc_issue',
  }

  # Ensure remote login warnig banner is configured properly - Section 1.7.1.3
  # Ensure permissions on /etc/issue.net are configured - Section 1.7.1.6
  file { '/etc/issue.net':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cis_hardening/etc_issue_net',
  }

  # Ensure GDM login banner is configured - Section 1.7.2

}
