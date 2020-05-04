require 'spec_helper'

describe 'cis_hardening::services::special' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for main class
      it { is_expected.to contain_class('cis_hardening::services::special')}
        
      # Ensure Time Synchronization is in use - Section 2.2.1.1
      it { is_expected.to contain_package('ntp').with(
        'ensure' => 'present',
      )}

      it { is_expected.to contain_package('chrony').with(
        'ensure' => 'present',
      )}

      # Ensure that ntp is configured - Section 2.2.1.2
      it { is_expected.to contain_file('/etc/ntp.conf').with(
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/cis_hardening/ntp_conf',
      ).that_requires('Package[ntp]')}

      it { is_expected.to contain_file('/etc/sysconfig/ntpd').with(
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/cis_hardening/etc_sysconfig_ntpd',
      ).that_requires('File[/etc/ntp.conf')}

      it { is_expected.to contain_file_line('ntp_options').with(
        'ensure' => 'present',
        'path'   => '/usr/lib/systemd/system/ntpd.service',
        'line'   => 'ExecStart=/usr/sbin/ntpd -u ntp:ntp $OPTIONS',
        'match'  => '^ExecStart=/usr/sbin/ntpd -u ntp:ntp $OPTIONS',
      )}

      # Ensure Chrony is Configured - Section 2.2.1.3
      

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
