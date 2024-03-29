# @summary A manifest to set filesystem configurations according to CIS hardening guidelines
#
# Section 1
#
# @example
#   include cis_hardening::setup::filesystem
class cis_hardening::setup::filesystem {

  # Section 1.1 - Filesystem Configuration
  # Disable unused Filesystems - Section 1.1.1

  # Ensure CIS.conf exists to add following to
  file { '/etc/modprobe.d/CIS.conf':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Ensure mounting of cramfs filesystems is disabled - Section 1.1.1.1
  file_line { 'cramfs_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install cramfs /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  # Ensure mounting of freevxfs filesystems is disabled - Section 1.1.1.2
  file_line { 'freevxfs_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install freevxfs /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  # Ensure mounting of jffs2 Filesystems is disabled - Section 1.1.1.3
  file_line { 'jffs2_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install jffs2 /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  # Ensure mounting of hfs filesystems is disabled - Section 1.1.1.4
  file_line { 'hfs_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install hfs /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  # Ensure mounting of hfsplus filesystems is disabled - Section 1.1.1.5
  file_line { 'hfsplus_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install hfsplus /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  # Ensure mounting of squashfs filesystems is disabled - Section 1.1.1.6
  file_line { 'squashfs_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install squashfs /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  # Ensure mounting of udf filesystem is disabled - Section 1.1.1.7
  file_line { 'udf_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install udf /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  # Ensure mounting of FAT filesystems (vfat) is disabled - Section 1.1.1.8
  file_line { 'vfat_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install vfat /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  # Ensure separate partition exists for /tmp - Section 1.1.2
  # Ensure nodev option set on /tmp partition - Section 1.1.3
  # Ensure nosuid option set on /tmp partition - Section 1.1.4
  # Ensure noexec option set on /tmp partition - Section 1.1.5

  # Section 1.1.2
  exec { 'checktmp_part':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /tmp not on own parittion!"',
    onlyif  => 'test ! "mount | grep /tmp" ',
  }

  # Section 1.1.3
  exec { 'chktmp_nodev':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p creit "Partition /tmp is not set nodev!"',
    onlyif  => 'test ! mount |grep /tmp |grep nodev',
  }

  # Section 1.1.4
  exec { 'chktmp_nosuid':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /tmp is not set nosuid"',
    onlyif  => 'test ! mount |grep /tmp |grep nosuid',
  }

  # Section 1.1.5
  exec { 'chktmp_noexec':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Filesystem /tmp is not set noexec"',
    onlyif  => 'test ! mount |grep /tmp |grep noexec',
  }

  # Ensure separate partition exists for /var - Section 1.1.6
  exec { 'chkvar_part':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var is not on its own partition"',
    onlyif  => 'test ! mount |grep /var',
  }

  # Ensure separate partition exists for /var/tmp - Section 1.1.7
  exec { 'chkvartmp_part':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var/tmp is not on its own partition"',
    onlyif  => 'test ! mount |grep "/var/tmp"',
  }

  # Ensure nodev option set on /var/tmp partition - Section 1.1.8
  exec { 'chkvartmp_nodev':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var/tmp does not have the nodev option set"',
    onlyif  => 'test ! mount |grep /var/tmp |grep nodev',
  }

  # Ensure nosuid set on /var/tmp partition - 1.1.9
  exec { 'chkvartmp_nosuid':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var/tmp does not have the nosuid option set"',
    onlyif  => 'test ! mount |grep /var/tmp |grep nosuid',
  }

  # Ensure noexec option set on /var/tmp partition - Section 1.1.10
  exec { 'chkvartmp_noexec':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var/tmp does not have the noexec option set"',
    onlyif  => 'test ! mount |grep /var/tmp |grep noexec',
  }

  # Ensure separate partition exists for /var/log - Section 1.1.11
  exec { 'chkvarlog_part':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var/log is not on its own parition."',
    onlyif  => 'test ! mount |grep /var/log',
  }

  # Ensure separate parition exists for /var/log/audit - Section 1.1.12
  exec { 'chkvarlogtmp_part':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var/log/audit is not on its own partition"',
    onlyif  => 'test ! mount |grep /var/log/audit',
  }

  # Ensure separate parittion exists for /home - Section 1.1.13
  exec { 'chkhome_part':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Parition /home is not on its own parition."',
    onlyif  => 'test ! mount |grep /home',
  }

  # Ensure nodev option is set on /home partition - Section 1.1.14
  exec { 'chkhome_nodev':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /home does not have the nodev option set"',
    onlyif  => 'test ! mount |grep /home |grep nodev',
  }

  # Ensure nodev option set on /dev/shm parition - Section 1.1.15
  exec { 'chkdevshm_nodev':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Parition /dev/shm does not have the nodev option set."',
    onlyif  => 'test ! mount |grep /dev/shm |grep nodev',
  }

  # Ensure nosuid option set on /dev/shm parition - Section 1.1.16
  exec { 'chkdevshm_nosuid':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /dev/shm does not have the nosuid option set."',
    onlyif  => 'test ! mount |grep /dev/shm |grep nosuid',
  }

  # Ensure noexec option set on /dev/shm parition - Section 1.1.17
  exec { 'chkdevshm_noexec':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /dev/shm does not have the noexec option set."',
    onlyif  => 'test ! mount |grep /dev/shm |grep noexec',
  }

  # Ensure nodev option set on removable media partitions - Section 1.1.18
  # Ensure nosuid option set on removable media partitions - Section 1.1.19
  # Ensure noexec option set on removable media paritions - Section 1.1.20
  #
  # NOTE: These steps require manual inspection and action based on observations

  # Ensure sticky bit is set on all world-writable directories - Section 1.1.21
  #
  # NOTE: This step requires manual inspection and action based on observations

  # Disable Automounting - Section 1.1.22
  service { 'autofs':
    ensure     => 'stopped',
    enable     => false,
    hasstatus  => true,
    hasrestart => true,
  }

}
