require 'spec_helper'

describe 'cis_hardening' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      it { is_expected.to contain_class('cis_hardening')}
      it { is_expected.to contain_class('cis_hardening::auth')}
      it { is_expected.to compile.with_all_deps }
    end
  end
end
