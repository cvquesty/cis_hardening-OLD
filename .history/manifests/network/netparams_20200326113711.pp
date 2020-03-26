# @summary A manifest to configure Networking parameters according to CIS Hardening Guidelines
#
# Section 3.1
#
# @example
#   include cis_hardening::network::netparams
class cis_hardening::network::netparams {

  # Restart sysctl section to enact changes
  exec { 'restart_sysctl':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => '/sbin/sysctl -p',
  }

  # Add Parameters to Existing sysctl.conf File
  # Ensure IP Forwarding is disabled - Section 3.1.1
  file_line { 'ipforward_disable':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.ip_forward = 0',
    notify => Exec['restart_sysctl'],
  }

  # Ensure packet redirect sending is disabled - Section 3.1.2
  file_line { 'redirect_all_disable':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.all.send_redirects = 0',
    notify => Exec['restart_sysctl'],
  }

  file_line { 'redirect_default_disable':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    notify => Exec['restart_sysctl'],
  }

  # Network Parameters for Host and Router - Section 3.2
  # Ensure source routed packets are not accepted - Section 3.2.1
  file_line { 'source_route_all':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.all.accept_source_route = 0',
    notify => Exec['restart_sysctl'],
  }

  file_line { 'source_route_default':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.default.accept_source_route = 0',
    notify => Exec['restart_sysctl'],
  }

  # Ensure ICMP redirects are not accepted - Section 3.2.2
  file_line  {'icmp_redirects_all':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.all.accept_redirects = 0',
    notify => Exec['restart_sysctl'],
  }

  file_line { 'icmp_redirects_default':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.default.accept_redirects = 0',
    notify => Exec['restart_sysctl'],
  }

}
