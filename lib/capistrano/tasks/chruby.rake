namespace :chruby do
  task :map_bins do
    if ruby_version = fetch(:chruby_ruby)
      chruby_prefix = "#{fetch(:chruby_exec)} #{ruby_version} --"
    else
      chruby_prefix = "#{fetch(:chruby_exec)} `cat .ruby-version` --"
    end

    SSHKit.config.command_map[:chruby_prefix] = chruby_prefix

    fetch(:chruby_map_bins).each do |command|
      SSHKit.config.command_map.prefix[command.to_sym].unshift(chruby_prefix)
    end
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'chruby:map_bins'
end

namespace :load do
  task :defaults do
    set :chruby_map_bins, %w{rake gem bundle ruby}
    set :chruby_exec, "/usr/local/bin/chruby-exec"
  end
end
