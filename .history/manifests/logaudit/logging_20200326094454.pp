# @summary A manifest to configuring the logging subsystem according to CIS 
# hardening guidelines
#
# Section 4.2 - Configure Logging
#
# @example
#   include cis_hardening::logaudit::logging
class cis_hardening::logaudit::logging {

  # Configure rsyslog - Section 4.2.1
  #
  # Ensure rsyslog service is enabled - Section 4.2.1.1
  service { 'rsyslog':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  # Ensure logging is configured - Section 4.2.1.2
  # Default logging setup covers all suggested filters in rsyslog for RHEL/CentOS 7  

  # Ensre rsyslog default file permissions configured - Section 4.2.1.3
  file_line { 'logfile_perms':
    ensure => 'present',
    path   => '/etc/rsyslog.conf',
    line   => '$FileCreateMode 0640',
  }
}
