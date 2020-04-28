require 'spec_helper'

describe 'cis_hardening::setup::secboot' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for the default class
      it { is_expected.to contain_class('cis_hardening::setup::secboot')}

      # Ensure permissions on bootloader config are configured - Section 1.4.1
      it { is_expected.to contain_file(/boot/grub2/grub.cfg).with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0600',
      )}
        
      it { is_expected.to contain_file('/boot/grub2/user.cfg').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0600',
      )}


      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
