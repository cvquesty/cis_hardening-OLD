require 'spec_helper'

describe 'cis_hardening::auth::accounts' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::auth::accounts')}

      # Check that exec resource exists to set pass_max_days 
      it { is_expected.to contain_exec('pass_max_days').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/^PASS_MAX_DAYS.*$/PASS_MAX_DAYS 7/' /etc/login.defs",
        'onlyif'  => "test `grep ^PASS_MAX_DAYS /etc/login.defs |awk '{print \$2}'` -gt 7",
      )}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
