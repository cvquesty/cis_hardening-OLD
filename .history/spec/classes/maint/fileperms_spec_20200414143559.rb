require 'spec_helper'

describe 'cis_hardening::maint::fileperms' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default Class
      it { is_expected.to contain_class('cis_hardening::maint::fileperms')}

      # Ensure that Ensure permissions on /etc/passwd are configured - Section 6.1.2
      it { is_expected.to contain_file('/etc/passwd').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      )}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
