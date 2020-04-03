# @summary A manifest to configure user and group settings according to CIS Hardening Guidelines
#
# Section 6.2
#
# @example
#   include cis_hardening::maint::usersgroups
class cis_hardening::maint::usersgroups {

  # Ensure password fields are not empty - Section 6.2.1
  exec { 'find_empty_pw':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "cat /etc/shadow |awk -F: '($2 == "") { print $1 " does not have a password"}'",
  }

}
