# @summary A manifest to set filesystem configurations according to CIS hardening guidelines
#
# Section 1
#
# @example
#   include cis_hardening::setup::filesystem
class cis_hardening::setup::filesystem {

# Section 1.1 - Filesystem Configuration
# Disable unused Filesystems - Section 1.1.1

# Ensure mounting of cramfs filesystems is disabled - Section 1.1.1.1
file_line { 'cramfs_disable':
  ensure => 'present',
  path   => '/etc/modprobe.d/CIS.conf',
  line   => 'install cramfs /bin/true',
}

# Ensure mounting of freevxfs filesystems is disabled - Section 1.1.1.2
file_line { 'freevxfs_disable':
  ensure => 'present',
  path   => '/etc/modprobe.d/CIS.conf',
  line   => 'install freevxfs /bin/true',
}

# Ensure mounting of jffs2 Filesystems is disabled - Section 1.1.1.3
file_line { 'jffs2_disable':
  ensure => 'present',
  path   => '/etc/modprobe.d/CIS.conf',
  line   => 'install jffs2 /bin/true',
}

# Ensure mounting of hfs filesystems is disabled - Section 1.1.1.4
file_line { 'hfs_disable':
  ensure => 'present',
  path   => '/etc/modprobe.d/CIS.conf',
  line   => 'install hfs /bin/true',
}

# Ensure mounting of hfsplus filesystems is disabled - Section 1.1.1.5
file_line { 'hfsplus_disable':
  ensure => 'present',
  path   => '/etc/modprobe.d/CIS.conf',
  line   => 'install hfsplus /bin/true',
}


}
