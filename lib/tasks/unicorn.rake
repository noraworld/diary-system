namespace :unicorn do

  # Tasks
  desc "Start unicorn"
  task(:start) {
    config      = Rails.root.join('config', 'unicorn.rb')
    environment = ENV['RAILS_ENVIRONMENT'] || ENV['RAILS_ENV'] || 'development'
    sh "unicorn -c #{config} -E #{environment} -D"
  }

  desc "Stop unicorn"
  task(:stop) {
    unicorn_signal :QUIT
  }

  desc "Restart unicorn with USR2"
  task(:restart) {
    unicorn_signal :USR2
  }

  desc "Increment number of worker processes"
  task(:increment) {
    unicorn_signal :TTIN
  }

  desc "Decrement number of worker processes"
  task(:decrement) {
    unicorn_signal :TTOU
  }

  desc "Unicorn pstree (depends on pstree command)"
  task(:pstree) do
    sh "pstree '#{unicorn_pid}'"
  end

  # Helpers
  def unicorn_signal signal
    Process.kill signal, unicorn_pid
  end

  def unicorn_pid
    begin
      File.read(ENV['UNICORN_PID']).to_i
    rescue Errno::ENOENT
      raise "Unicorn does not seem to be running"
    end
  end

end
