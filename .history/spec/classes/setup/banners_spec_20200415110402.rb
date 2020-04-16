require 'spec_helper'

describe 'cis_hardening::setup::banners' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for main class
      it { is_expected.to contain_class('cis_hardening::setup::banners')}

      # Ensure message of the day (MOTD) is properly configured - Section 1.7.1.1,
      # Ensure permisisons on /etc/motd are configured - Section 1.7.1.4
      it { is_expected.to contain_file('/etc/motd').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
        'source' => 'puppet:///modules/cis_hardening/etc_motd',
      )}

      # Ensure local login warning banner is configured properly - Section 1.7.1.2
      # Ensure permissions on /etc/issue are configured - Section 1.7.1.5
      it { is_expected.to contain_file('/etc/issue').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
        'source' => 'puppet:///modules/cis_hardening/etc_issue',
      )}


      # Ensure it compikles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
