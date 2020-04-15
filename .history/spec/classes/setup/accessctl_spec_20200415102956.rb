require 'spec_helper'

describe 'cis_hardening::setup::accessctl' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::setup::accessctl')}

      # Ensure SELinux is not disabled in bootloader configuration - Section 1.6.1.1
      it { is_expected.to contain_file_line('grub_selinux_default').with(
        'ensure' => 'present',
        'path'   => '/etc/default/grub',
        'line'   => 'GRUB_CMDLINE_LINUX_DEFAULT="quiet"',
        'match'  => '^GRUB_CMDLINE_LINUX_DEFAULT\=',
      )}

      it { is_expected.to contain_file_line('grub_selinux').with(
        'ensure' => 'present',
        'path'   => '/etc/default/grub',
        'line'   => 'GRUB_CMDLINE_LINUX=""',
        'match'  => '^GRUB_CMDLINE_LINUX\=',
      )}

      # Ensure it compiles with all dependencies
      it { is_expected.to compile }
    end
  end
end
