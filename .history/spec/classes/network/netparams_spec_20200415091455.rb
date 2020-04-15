require 'spec_helper'

describe 'cis_hardening::network::netparams' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::network::netparams')}

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

      it { is_expected.to contain_file_line('redirect_default_disable').with(
        'ensure' => 'present',
        'path'   => '/etc/sysctl.d/99-sysctl.conf',
        'line'   => 'net.ipv4.conf.default.send_redirects = 0',
      ).that_notifies('Exec[restart_sysctl]')}

      # Ensure source routed packets are not accepted - Section 3.2.1
      it { is_expected.to contain_file_line('source_route_all').with(
        'ensure' => 'present',
        'path'   => '/etc/sysctl.d/99-sysctl.conf',
        'line'   => 'net.ipv4.conf.all.accept_source_route = 0',
      )}

      # Ensure it compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
