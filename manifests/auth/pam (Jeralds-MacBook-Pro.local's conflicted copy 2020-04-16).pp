# @summary A manifest to configure the PAM subsystem according to CIS
# hardening guidelines
#
# Section 5.3
#
# Hardens PAM in line with CIS standards for CentOS 7.x Servers
#
class cis_hardening::auth::pam {

  # Ensure Password creation requirements are configured - Section 5.3.1
  file { '/etc/security/pwquality.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cis_hardening/pwquality.conf',
  }

  file_line { 'sysauth_pwquality':
    path => '/etc/pam.d/system-auth',
    line => 'password requisite pam_pwquality.so try_first_pass retry=3',
  }

  file_line { 'pwauth_pwquality':
    path => '/etc/pam.d/password-auth',
    line => 'password requisite pam_pwquality.so try_first_pass retry=3',
  }

  # Ensure lockout for failed password attempts is configured - Section 5.3.2
}
