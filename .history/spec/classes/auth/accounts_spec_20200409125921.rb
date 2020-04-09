require 'spec_helper'

describe 'cis_hardening::auth::accounts' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::auth::accounts')}

      # Check that Ensure Password expiration is 365 days or less - Section 5.4.1.1
      it { is_expected.to contain_exec('pass_max_days').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^PASS_MAX_DAYS.*$/PASS_MAX_DAYS 365/' /etc/login.defs",
        'onlyif'  => "test `grep ^PASS_MAX_DAYS /etc/login.defs |awk '{print \$2}'` -gt 365",
      )}

      # Check that Ensure minimum days between password changes is 7 or more - Section 5.4.1.2
      it { is_expected.to contain_exec('pass_min_days').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^PASS_MIN_DAYS.*$/PASS_MIN_DAYS 7/' /etc/login.defs",
        'onlyif'  => "test `grep ^PASS_MIN_DAYS /etc/login.defs |awk '{print \$2}'` -gt 7",
      )}

      # Check that Ensure Pasword Expiration warning days is 7 or more - Section 5.4.1.3
      it { is_expected.to contain_exec('pass_warn_age').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/PASS_WARN_AGE.*$/PASS_WARN_AGE 7/' /etc/login.defs",
        'onlyif'  => "test `grep ^PASS_WARN_AGE /etc/logn.defs |awk '{print \$2}'` -lt 7",
      )}

      # Check that Ensure default group for the root account is GID 0 - Section 5.4.3
      it { is_expected.to contain_user('root').with(
        'ensure' => 'present',
        'gid'    => 'root',
      )}

      # Check that Ensure default user umask is 027 or more restrictive - Section 5.4.4
      it { is_expected.to contain_exec('set_login_umask_etcprofile').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/umask.*$/umask 027/' /etc/profile",
        'onlyif'  => 'test `grep umask /etc/profile`',
      )}

      it { is_expected.to contain_exec('set_login_umask_etcbashrc').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/umask.*$/umask027/' /etc/bashrc",
        'onlyif'  => 'test `grep umask /etc/bashrc`',
      )}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
