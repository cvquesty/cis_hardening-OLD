# @summary A manifest to configure IPv6 according to CIS hardening guidelines
#
# Section 3.3 - IPv6
#
# @example
#   include cis_hardening::network::ipv6
class cis_hardening::network::ipv6 {

  # Ensure IPv6 router advertisements are not accepted - Section 3.3.1
  file_line { 'ipv6_accept_ra_all':
    ensure  => 'present',
    path    => '/etc/sysctl.d/99-sysctl.conf',
    line    => 'net.ipv6.conf.all.accept_ra = 0',
    notify  => Exec['restart_sysctl'],
    require => Class['cis_hardening::network::netparams'],
  }

  file_line { 'ipv6_acept_ra_default':
    ensure  => 'present',
    path    => '/etc/sysctl.d/99-sysctl.conf',
    line    => 'net.ipv6.conf.default.accept_ra = 0',
    notify  => Exec['restart_sysctl'],
    require => Class['cis_hardening::network::netparams'],
  }

  # Ensure IPv6 redirets are not accepted - Section 3.3.2
  file_line { 'ipv6_accept_redirects_all':
    ensure  => 'present',
    path    => '/etc/sysctl.d/99-sysctl.conf',
    line    => 'net.ipv6.conf.all.accept_redirects = 0',
    notify  => Exec['restart_sysctl'],
    require => Class['cis_hardening::network::netparams'],
  }

  file_line { 'ipv6_accept_redirects_default':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv6.conf.default.accept_redirects = 0',
    notify => Exec['restart_sysctl'],
  }

  # Ensure IPv6 is Disabled - Section 3.3.3
  # Manual procedures related to Grub, requires manual inspection

}
