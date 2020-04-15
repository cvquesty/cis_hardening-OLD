require 'spec_helper'

describe 'cis_hardening::network::ipv6' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::network::ipv6')}

      # Ensure restart method for sysctl ipv6 controls exists
      it { is_expected.to contain_exec('restart_ipv6_sysctl').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => '/sbin/sysctl -p',
      )}

      # Ensure it compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
