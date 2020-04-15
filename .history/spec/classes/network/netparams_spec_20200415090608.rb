require 'spec_helper'

describe 'cis_hardening::network::netparams' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is-expected.to contain_class('cis_hardening::network::netparams')}

      # Ensure it compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
