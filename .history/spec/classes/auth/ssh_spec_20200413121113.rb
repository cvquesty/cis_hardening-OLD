require 'spec_helper'

describe 'cis_hardening::auth::ssh' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      
      # Check for default class
      it { is_expected.to contain_class('cis_hardening::auth::ssh')}

      # Ensure that Ensure permissions on /etc/ssh/sshd_config are configured - Section 5.2.1
      it { is_expected.to contain_file('/etc/ssh/sshd_config').with(
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0600',
      )}

      # Ensure that Set sshd_config Options - Section 5.2.2
      it { is_expected.to contain_exec('set_ssh_protocol').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^#Protocol.*$/Protocol 2/' /etc/ssh/sshd_config",
        'onlyif'  => 'test ! "grep ^Protocol /etc/ssh/sshd_config"',
      )}

      # Ensure that Set SSH LogLevel to INFO - Section 5.2.3
      it { is_expected.to contain_exec('set_ssh_loglevel').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^#LogLevel.*$/LogLevel INFO/' /etc/ssh/sshd_config",
        'onlyif'  => 'test ! "grep ^LogLevel /etc/ssh/sshd_config"',
      )}

      # Ensure that Ensure SSH X11 Forwarding is disabled - Section 5.2.4
      it { is_expected.to contain_exec('set_x11_forwarding').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^#X11Forwarding.*$/X11Forwarding no/' /etc/ssh/sshd_config",
        'onlyif'  => 'test ! "grep ^X11Forwarding /etc/ssh/sshd_config"',
      )}

      # Ensure that Ensure SSH MaxAuthTries is set to 4 or less - Section 5.2.5
      it { is_expected.to contain_exec('set_ssh_maxauthtries').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^#MaxAuthTries.*$/MaxAuthTries 4/' /etc/ssh/sshd_config",
        'onlyif'  => 'test ! "grep ^MaxAuthTries /etc/ssh/sshd_config"',
      )}

      # Ensure that Ensure SSH IgnoreRhosts is enabled - Section 5.2.6
      it { is_expected.to contain_exec('set_ssh_ignore_rhosts').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^#IgnoreRhosts.*$/IgnoreRhosts yes/' /etc/ssh/sshd_config",
        'onlyif'  => 'test ! "grep ^IgnoreRhosts /etc/ssh/sshd_config"',
      )}

      # Ensure that Ensure SSH HostBased Authentication is Disabled - Section 5.2.7
      it { is_expected.to contain_exec('set_hosbasedauth_off').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^#HostbasedAuthentication.*$/HostbasedAuthentication no/' /etc/ssh/sshd_config",
        'onlyif'  => 'test ! "grep ^HostbasedAuthentication /etc/ssh/sshd_config"',
      )}
        
      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
