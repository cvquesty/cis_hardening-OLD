# @summary A manifest to configure filesystem permissions as per CIS Hardening GUidelines
#
# Section 6.1
#
# @example
#   include cis_hardening::maint::fileperms
class cis_hardening::maint::fileperms {

  # 6.1.1 Audit System File Permissions
  #
  # This item requires manual execution and inspection of output. It suggests a manual 
  # inspection of all installed packages on the system, which is marginally infeasible.
  # acceptance of risk for this item is encouraged, lest Puppet runs take entirely too
  # much time and unnecessarily load the system.

}
