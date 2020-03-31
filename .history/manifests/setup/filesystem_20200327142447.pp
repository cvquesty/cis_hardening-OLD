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

# Ensure mounting of squashfs filesystems is disabled - Section 1.1.1.6
file_line { 'squashfs_disable':
  ensure => 'present',
  path   => '/etc/modprobe.d/CIS.conf',
  line   => 'install squashfs /bin/true',
}

# Ensure mounting of udf filesystem is disabled - Section 1.1.1.7
file_line { 'udf_disable':
  ensure => 'present',
  path   => '/etc/modprobe.d/CIS.conf',
  line   => 'install udf /bin/true',
}

# Ensure mounting of FAT filesystems (vfat) is disabled - Section 1.1.1.8
file_line { 'vfat_disable':
  ensure => 'present',
  path   => '/etc/modprobe.d/CIS.conf',
  line   => 'install vfat /bin/true',
}

# Ensure separate partition exists for /tmp - Section 1.1.2
# Ensure nodev option set on /tmp partition - Section 1.1.3
# Ensure nosuid option set on /tmp partition - Section 1.1.4
# Ensure noexec option set on /tmp partition - Section 1.1.5


# Section 1.1.2
exec { 'checktmp_part':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
  command => 'logger -p crit "Filesystem /tmp not on own parittion!"',
  onlyif  => 'test ! "mount | grep ^/tmp" '
}



}
