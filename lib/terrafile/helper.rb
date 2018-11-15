module Terrafile
  module Helper
    def self.run!(command)
      begin
        _stdout, stderr, status = Open3.capture3(command)
      rescue Errno::ENOENT => error
        raise Error, "'#{command}' failed (#{error})"
      end

      unless status.success?
        raise Error, "'#{command}' failed with exit code #{status.exitstatus} " \
                        "(#{stderr.chomp})"
      end

      true
    end

    def self.run_with_output(command)
      begin
        stdout, _stderr, _status = Open3.capture3(command)
      rescue Errno::ENOENT => error
        raise Error, "'#{command}' failed (#{error})"
      end

      stdout.chomp
    end

    def self.clone(source, destination)
      run!("git clone #{source} #{destination} 1> /dev/null")
    end

    def self.dir_exists?(path)
      Dir.exist?(path)
    end

    def self.file_exists?(path)
      File.exist?(path)
    end

    def self.repo_up_to_date?(version)
      current_tag = run_with_output('git describe --tags').tr("\n", '')
      current_hash = run_with_output('git rev-parse HEAD').tr("\n", '')
      [current_tag, current_hash].include? version
    end

    def self.pull_repo
      run!('git pull 1> /dev/null')
    end
  end
end
