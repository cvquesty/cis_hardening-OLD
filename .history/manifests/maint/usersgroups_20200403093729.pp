# @summary A manifest to configure user and group settings according to CIS Hardening Guidelines
#
# Section 6.2
#
# @example
#   include cis_hardening::maint::usersgroups
class cis_hardening::maint::usersgroups {

  # Ensure password fields are not empty - Section 6.2.1
  #
  # NOTE: NOTE: This command is a manual command with manual inspection and remedation of the output.
  #
  # Run the following command and verify that no output is returned:
  #
  # cat /etc/shadow | awk -F: '($2 == "") { print $1 " does not have a password"}'
  #
  # If any accounts are returned, lock the account until it can be determined why it does not have a
  # password:
  #
  # passwd -l <username> 
  #

  

}
