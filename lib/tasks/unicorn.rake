# frozen_string_literal: true

namespace :unicorn do
  # Tasks
  desc 'Start unicorn'
  task(:start) do
    config      = Rails.root.join('config', 'unicorn.rb')
    environment = ENV['RAILS_ENVIRONMENT'] || ENV['RAILS_ENV'] || 'development'
    sh "unicorn -c #{config} -E #{environment} -D"
  end

  desc 'Stop unicorn'
  task(:stop) do
    unicorn_signal :QUIT
  end

  desc 'Restart unicorn with USR2'
  task(:restart) do
    unicorn_signal :USR2
  end

  desc 'Increment number of worker processes'
  task(:increment) do
    unicorn_signal :TTIN
  end

  desc 'Decrement number of worker processes'
  task(:decrement) do
    unicorn_signal :TTOU
  end

  desc 'Unicorn pstree (depends on pstree command)'
  task(:pstree) do
    sh "pstree '#{unicorn_pid}'"
  end

  # Helpers
  def unicorn_signal(signal)
    Process.kill signal, unicorn_pid
  end

  def unicorn_pid
    File.read(ENV['UNICORN_PID']).to_i
  rescue Errno::ENOENT
    raise 'Unicorn does not seem to be running'
  end
end
