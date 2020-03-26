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
  }

  # Ensure packet redirect sending is disabled - Section 3.1.2
  file_line { 'redirect_disable':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 
  }

}
