# @summary A manifest to configure additional process hardening according to CIS hardening guidelines
#
# Section 1.5 - Additional Process Hardening
#
# @example
#   include cis_hardening::setup::accessctl
class cis_hardening::setup::accessctl {

  # Ensure Core Dumps are restricted - Section 1.5.1
  file_line { 'core_limits':
    ensure => 'present',
    path   => '/etc/security/limits.conf',
    line   => '* hard core 0',
  }

  file_line { 'fs_dumpable':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'fs.suid_dumpable = 0',
  }

}
