# @summary A manifest to configure edge protocols in accordance with CIS Hardening Guidelines
#
# Section 3.5
#
# @example
#   include cis_hardening::network::edgeprotocols
class cis_hardening::network::edgeprotocols {

  # Ensure DCCP is disabled - Section 3.5.1
  file_line { 'dccp_disable':
    ensure => 'present',
    path   => '/etc/modprobe.d/CIS.conf',
    line   => 'install dccp /bin/true',
  }

  


}
