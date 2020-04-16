require 'spec_helper'

describe 'cis_hardening::setup::filesystem' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::setup::filesystem')}

      # Ensure mounting of cramfs filesystems is disabled - Section 1.1.1.1
      it { is_expected.to contain_file_line('cramfs_disable').with(
        'ensure' => 'present',
        'path'   => '/etc/modprobe.d/CIS.conf',
        'line'   => 'install cramfs /bin/true',
      )}

      # Ensure mounting of freevxfs filesystems is disabled - Section 1.1.1.2
      it { is_expected.to contain_file_line('freevxfs_disable').with(
        'ensure' => 'present',
        'path'   => '/etc/modprobe.d/CIS.conf',
        'line'   => 'install freevxfs /bin/true',
      )}

      # Ensure mounting of jffs2 Filesystems is disabled - Section 1.1.1.3
      it { is_expected.to contain_file_line('jffs2_disable').with(
        'ensure' => 'present',
        'path'   => '/etc/modprobe.d/CIS.conf',
        'line'   => 'install jffs2 /bin/true',
      )}

      # Ensure mounting of hfs filesystems is disabled - Section 1.1.1.4
      it { is_expected.to contain_file_line('hfs_disable').with(
        'ensure' => 'present',
        'path'   => '/etc/modprobe.d/CIS.conf',
        'line'   => 'install hfs /bin/true',
      )}

      # Ensure mounting of hfsplus filesystems is disabled - Section 1.1.1.5
      it { is_expected.to contain_file_line('hfsplus_disable').with(
        'ensure' => 'present',
        'path'   => '/etc/modprobe.d/CIS.conf',
        'line'   => 'install hfsplus /bin/true',
      )}
        
      # Ensure mounting of squashfs filesystems is disabled - Section 1.1.1.6
      it { is_expected.to contain_file_line('squashfs_disable').with(
        'ensure' => 'present',
        'path'   => '/etc/modprobe.d/CIS.conf',
        'line'   => 'install squashfs /bin/true',
      )}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
