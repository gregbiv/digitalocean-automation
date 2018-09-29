# Temp solution to mix between remote serverspec and local
# Could be removed once we move all hosts to kitchen verfiy
begin
  require_relative './helper_spec.rb'
rescue LoadError
  require 'serverspec'
  set :backend, :exec
end

describe 'Sudoers/Users Section' do
    # Define sudoers file
    sudoers_file = "/etc/sudoers"

    describe file("#{sudoers_file}") do
      it { should be_mode 440 }
      it { should be_owned_by 'root' }
    end

    describe group('admin') do
      it { should exist }
    end
#   describe command('cat #{sudoers_file}') do
#       its(:stdout) { should match /bin/ }
#    end

end

describe 'ssh Section' do
    describe file '/etc/ssh/sshd_config' do
      its(:content) { should contain(/\nPasswordAuthentication no/) }
    end

    describe file '/etc/ssh/sshd_config' do
      its(:content) { should contain(/\nPermitRootLogin no/) }
    end

    describe service('ssh'), :if => os[:family] == [ 'ubuntu'] do
      it { should be_running }
    end

    describe service('sshd'), :if => os[:family] == 'centos' do
      it { should be_running }
    end

    describe port(22) do
      it { should be_listening.on('0.0.0.0').with('tcp') }
    end
end

describe 'TimeZone stuff Section' do
    describe service('ntpd'), :if => os[:family] == ['centos', 'ubuntu'] do
      it { should be_running }
    end
    # Locale stuff
end

describe 'Make sure hostname is resolvable to 127.0.1.1' do
    describe command("ping -c 1 `hostname`") do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain(/(127.0.1.1)/) }
    end
end

describe 'Make sure hostname is resolvable to 127.0.1.1' do
    describe command("ping -c 1 `hostname`") do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain(/(127.0.1.1)/) }
    end
end
