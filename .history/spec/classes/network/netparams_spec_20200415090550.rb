require 'spec_helper'

describe 'cis_hardening::network::netparams' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is-expected.to contain_class('cis_hardening::network::netparams')}

      it { is_expected.to compile }
    end
  end
end
