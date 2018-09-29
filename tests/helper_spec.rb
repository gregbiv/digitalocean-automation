require 'rubygems'
require 'bundler/setup'
require 'serverspec'
require 'pathname'
require 'net/ssh'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true
  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # By default use ssh
  verify_conn = ENV['KITCHEN_VERIFY_CONN'] || "ssh"
  if verify_conn == "ssh"
    set :host, ENV['KITCHEN_HOSTNAME']
    # ssh options at http://net-ssh.github.io/net-ssh/Net/SSH.html#method-c-start
    set :ssh_options,
      :user => ENV['KITCHEN_USERNAME'],
      :port => ENV['KITCHEN_PORT'],
      :auth_methods => [ 'publickey' ],
      :keys => [ ENV['KITCHEN_SSH_KEY'] ],
      :keys_only => true,
      :paranoid => false,
      :use_agent => true,
      :verbose => :error
    set :backend, :ssh
    set :request_pty, true
    puts "serverspec config ssh '#{ENV['KITCHEN_USERNAME']}@#{ENV['KITCHEN_HOSTNAME']} -p #{ENV['KITCHEN_PORT']} -i #{ENV['KITCHEN_SSH_KEY']}'"
  elsif verify_conn == "exec"
    puts "serverspec :backend, :exec"
    set :backend, :exec
  else
    puts "invalid serverspec backend #{verify_conn}"
  end
end

if defined?(@ruby_files_to_load)
  @ruby_files_to_load.each { |ruby_file| require_relative ruby_file }
end

def do_request(new_config)
  command = Array.new
  command.push("curl")
  default_config = {}

  default_config[:resolve_hostname] = false
  default_config[:resolve_port] = [80,443]
  default_config[:resolve_map] = '127.0.0.1'
  default_config[:silent] = true # --silent
  default_config[:follow_redirect] = false # -L, --location
  default_config[:only_headers] = false # --head or  -I show headers only
  default_config[:headers] = false # --header, -H

  # Merge config
  config = default_config.merge(new_config)

  # Resolver
  if config[:resolve_hostname]
    if config[:resolve_hostname].kind_of? String
      config[:resolve_hostname] = [config[:resolve_hostname]]
    end

    config[:resolve_hostname].each do |host|
      config[:resolve_port].each do |port|
        resolve_command = "--resolve #{host}:#{port}:#{config[:resolve_map]}"
        command.push(resolve_command)
      end
    end
  end

  # Silent option
  command.push("--silent") if config[:silent]
  # Show only headers
  command.push("--head") if config[:only_headers]
  # follow Redirects
  command.push("--location") if config[:follow_redirect]
  # Headers
  if config[:headers]
    config[:headers].each do |key, value|
      command.push("--header '#{key}: #{value}'")
    end
  end

  # The actual url
  command.push(config[:hostname])
  command.join(' ')
end
