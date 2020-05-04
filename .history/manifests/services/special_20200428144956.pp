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



}
