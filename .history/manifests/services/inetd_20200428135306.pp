# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cis_hardening::services::inetd
class cis_hardening::services::inetd {

  # Ensure Chargen Services are not enabled - Section 2.1.1
  service { 'chargen-dgram':
    ensure     => 'stopped',
    enable     => false,
    hasstatus  => true,
    hasrestart => true,
  }

  service { 'chargen-stream':
    ensure     => 'stopped',
    enable     => false,
    hasstatus  => true,
    hasrestart => true,
  }

  # Ensure Daytime services are not enabled - Section 2.1.2
  service { 'daytime-dgram':
    ensure     => 'stopped',
    enable     => false,
    hasstatus  => true,
    hasrestart => true,
  }

  service { 'daytime-stream':
    ensure     => 'stopped',
    enable     => false,
    hasstatus  => true,
    hasrestart => true,
  }

  # Ensure discard services are not enabled - Section 2.1.3
  service { 'discard-dgram':
    ensure => 'stopped',
    enable     => false,
    hasstatus  => true,
    hasrestart => true,
  }

  service { 'discard-stream':
    ensure => 'stopped',
    enable     => false,
    hasstatus  => true,
    hasrestart => true,
  }
}
