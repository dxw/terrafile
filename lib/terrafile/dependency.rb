module Terrafile
  class Dependency
    def initialize(name:, source:, version:)
      @name = name
      @source = source
      @version = version
    end

    attr_reader :name, :source, :version

    def self.build_from_terrafile
      (YAML.safe_load(File.read(TERRAFILE_PATH)) || []).map do |module_name, details|
        new(
          name: module_name,
          version: details['version'],
          source: details['source']
        )
      end
    end

    def fetch
      return Helper.clone(source, name) unless Helper.dir_exists?(name)

      Dir.chdir(name) do
        Helper.pull_repo unless Helper.repo_up_to_date?(version)
      end
    end

    def checkout
      Dir.chdir(name) do
        Helper.run!("git checkout #{version} 1> /dev/null")
      end
    rescue Error => error
      raise unless error.message.match?(/reference is not a tree/)

      Kernel.puts "[*] WARN: #{error} ." \
        "The 'version' should be the branch name or tag, rather than the SHA."
    end
  end
end
