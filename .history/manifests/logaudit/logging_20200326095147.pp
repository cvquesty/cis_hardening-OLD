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

  # Ensure rsyslog is configured to send logs to a remote log host - Section 4.2.1.4
  # file_line { 'remote_loghost':
  #  ensure => 'present',
  #  path   => '/etc/rsyslog.conf',
  #  line   => '*.* @@loghost.example.com',
  #}
  # 
  # NOTE: Uncomment above and populate "line" attribute with appropriate syslog server.

  # Ensure remote rsyslog messages are only accepted on designated log hosts - Section 4.2.1.5
  # add imtcp setting
  #file_line { 'imtcp_log':
  #  ensure => 'present',
  #  path   => '/etc/rsyslog.conf',
  #  line   => '$ModLoad imtcp',
  #}

  # Add in port for logging
  #file_line { 'logport':
  #  ensure => 'present',
  #  path   => '/etc/rsyslog.conf',
  #  line   => '$INPUTTCPSERVERRUN 514',
  #}
}
