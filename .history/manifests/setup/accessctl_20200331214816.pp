# @summary A manifest to configure Mandatory Access Control as per CIS hardening guidelines
#
# 1.6 - Mandatory Access Control
#
# @example
#   include cis_hardening::setup::accessctl
class cis_hardening::setup::accessctl {
  
  # Configure SELinux - Section 1.6.1

  # Ensure SELinux is not disabled in bootloader configuration - Section 1.6.1.1
  file_line { 'grub_selinux_default':
    ensure => 'present',
    path   => '/etc/default/grub',
    line   => 'GRUB_CMDLINE_LINUX_DEFAULT="quiet"',
    match  => '^GRUB_CMDLINE_LINUX_DEFAULT\=',
  }

  file_line { 'grub_selinux':
    ensure => 'present',
    path   => '/etc/default/grub',
    line   => 'GRUB_CMDLINE_LINUX=""',
    match  => '^GRUB_CMDLINE_LINUX\=',
  }
  
  # Ensure the SELinux state is "enforcing" - Section 1.6.1.2
  file_line { 'selinux_state':
    ensure => 'present',
    path   => '/etc/selinux/config',
    line   => 'SELINUX=enforcing',
    match  => '^SELINUX\=',
  }

  # Ensure SELINUX Policy is configured - Section 1.6.1.3
  file_line { 'selinux_policy':
    ensure => 'present',
    path   => '/etv/selinux/config',
    line   => 'SELINUXTYPE=targeted',
    match  => '^SELINUXTYPE\=',
  }

}
