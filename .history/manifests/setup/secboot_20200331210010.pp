# @summary A manifest to configure secure boot settings according to CIS hardening guidelines
#
# Section 1.4 - Secure Boot Settings
#
# @example
#   include cis_hardening::setup::secboot
class cis_hardening::setup::secboot {

  # Ensure permissions on bootloader config are configured - Section 1.4.1
  file { '/boot/grub2/grub.cfg':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  file { '/boot/grub2/user.cfg':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }
}
