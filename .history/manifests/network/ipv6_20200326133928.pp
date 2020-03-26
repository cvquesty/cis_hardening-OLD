# @summary A manifest to configure IPv6 according to CIS hardening guidelines
#
# Section 3.3 - IPv6
#
# @example
#   include cis_hardening::network::ipv6
class cis_hardening::network::ipv6 {

  # Ensure IPv6 router advertisements are not accepted
  file_line { 'ipv6_accept_ra_all':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv6.conf.all.accept_ra = 0',
    notify => Exec['restart_sysctl'],
  }

  file_line { 'ipv6_acept_ra_default':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv6.conf.default.accept_ra = 0',
    notify => Exec['restart_sysctl'],
  }

}
