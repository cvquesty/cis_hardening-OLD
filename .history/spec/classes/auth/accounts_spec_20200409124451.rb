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

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
