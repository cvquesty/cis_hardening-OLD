# @summary A manifest to configure the PAM subsystem according to CIS
# hardening guidelines
#
# Section 5.3
#
# Hardens PAM in line with CIS standards for CentOS 7.x Servers
#
class cis_hardening::auth::pam {

  # Ensure Password creation requirements are configured
  file { '/etc/security/pwquality.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cis_hardening/pwquality.conf',
  }
}
