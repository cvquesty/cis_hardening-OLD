require 'spec_helper'

describe 'cis_hardening::auth::cron' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::auth::cron')}

      it { is_expected.to compile }
    end
  end
end
