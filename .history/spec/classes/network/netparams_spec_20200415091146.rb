require 'spec_helper'

describe 'cis_hardening::network::netparams' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is-expected.to contain_class('cis_hardening::network::netparams')}

      # Ensure Restart sysctl section to enact changes exists
      it { is_expected.to contain_exec('restart_sysctl').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => '/sbin/sysctl -p',
      )}

      # Ensure IP Forwarding is disabled - Section 3.1.1
      it { is_expected.to contain_file_line('ipforward_disable').with(
        'ensure' => 'present',
        'path'   => '/etc/sysctl.d/99-sysctl.conf',
        'line'   => 'net.ipv4.ip_forward = 0',
      ).that_notifies('Exec[restart_sysctl]')}

      # Ensure packet redirect sending is disabled - Section 3.1.2
      it { is_expected.to contain_file_line('redirect_all_disable').with(
        'ensure' => 'present',
        'path'   => '/etc/sysctl.d/99-sysctl.conf',
        'line'   => 'net.ipv4.conf.all.send_redirects = 0',
      ).that_notifies('Exec[restart_sysctl]')}

      # Ensure it compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
