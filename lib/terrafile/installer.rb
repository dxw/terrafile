module Terrafile
  class Installer
    MODULES_PATH = 'vendor/terraform_modules'.freeze
    TERRAFILE_PATH = 'Terrafile'.freeze

    def call
      read_terrafile
      create_modules_directory_if_needed
    end

    private

    def read_terrafile
      return YAML.safe_load(TERRAFILE_PATH) if File.exist?(TERRAFILE_PATH)

      puts '[*] Terrafile does not exist'
      exit 1
    end

    def create_modules_directory_if_needed
      return if Dir.exist?(MODULES_PATH)

      puts "[*] Creating Terraform modules directory at '#{MODULES_PATH}'"
      FileUtils.makedirs MODULES_PATH
    end
  end
end

# def modules_path
#   'vendor/terraform_modules'
# end

# def terrafile_path
#   'Terrafile'
# end

# def read_terrafile
#   if File.exist? terrafile_path
#     YAML.load_file terrafile_path
#   else
#     fail('[*] Terrafile does not exist')
#   end
# end

# def create_modules_directory
#   unless Dir.exist? modules_path
#     puts "[*] Creating Terraform modules directory at '#{modules_path}'"
#     FileUtils.makedirs modules_path
#   end
# end

# desc 'Fetch the Terraform modules listed in the Terrafile'
# task :terrafile do
#   terrafile = read_terrafile

#   create_modules_directory

#   terrafile.each do |module_name, repository_details|
#     source  = repository_details['source']
#     version = repository_details['version']
#     puts "[*] Checking out #{version} of #{source} ..."

#     Dir.mkdir(modules_path) unless Dir.exist?(modules_path)
#     Dir.chdir(modules_path) do
#       unless Dir.exist?("#{module_name}")
#         `git clone #{source} #{module_name} &> /dev/null`
#       else
#         Dir.chdir("#{module_name}") do
#           current_tag = `git describe --tags`.tr("\n",'')
#           current_hash = `git rev-parse HEAD`.tr("\n",'')
#           unless [current_tag, current_hash].include? version
#             `git pull &> /dev/null`
#           end
#         end
#       end
#       Dir.chdir("#{module_name}") do
#         `git checkout #{version} &> /dev/null`
#       end
#     end
#   end
# end
