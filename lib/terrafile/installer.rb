module Terrafile
  class Installer
    MODULES_PATH = 'vendor/terraform_modules'.freeze

    def initialize
      @dependencies = read_terrafile
    end

    def call
      create_modules_directory_if_needed
      checkout_modules
    end

    private

    attr_reader :dependencies

    def read_terrafile
      return built_dependencies if Helper.file_exists?(TERRAFILE_PATH)

      Kernel.puts '[*] Terrafile does not exist'
      Kernel.exit 1
    end

    def built_dependencies
      Dependency.build_from_terrafile
    end

    def checkout_modules
      Dir.chdir(Installer::MODULES_PATH) do
        dependencies.each do |dependency|
          msg = "Checking out #{dependency.version} from #{dependency.source}"
          Kernel.puts msg
          dependency.fetch
          dependency.checkout
        end
      end
    end

    def create_modules_directory_if_needed
      return if Helper.dir_exists?(MODULES_PATH)

      Kernel.puts "[*] Creating Terraform modules directory at '#{MODULES_PATH}'"
      FileUtils.makedirs MODULES_PATH
    end
  end
end
