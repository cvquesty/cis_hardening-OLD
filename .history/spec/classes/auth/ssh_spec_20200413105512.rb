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
        
      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
