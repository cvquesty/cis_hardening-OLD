# @summary A short summary of the purpose of this class
#
# Section 1.3 - Filesystem Integrity Checking
#
# @example
#   include cis_hardening::setup::fim
class cis_hardening::setup::fim {

  # Ensure AIDE is installed - Section 1.3.1
  package { 'aide':
    ensure => 'present',
  }

  

}
