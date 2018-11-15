require 'yaml'
require 'fileutils'
require 'open3'
require_relative 'terrafile/version'
require_relative 'terrafile/errors'
require_relative 'terrafile/helper'
require_relative 'terrafile/dependency'
require_relative 'terrafile/installer'

module Terrafile
  TERRAFILE_PATH = 'Terrafile'.freeze
  MODULES_PATH = File.join('vendor', 'terraform_modules').freeze
end
