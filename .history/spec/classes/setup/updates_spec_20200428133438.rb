require 'spec_helper'

describe 'cis_hardening::setup::updates' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for main class
      it { is_expected.to contain_class('cis_hardening::setup::updates')}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
