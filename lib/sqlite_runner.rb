require 'mumukit'
require 'erb'

I18n.load_translations_path File.join(__dir__, 'locales', '*.yml')

Mumukit.runner_name = 'sqlite'
Mumukit.configure do |config|
  config.docker_image = 'leandrojdl/mumuki-sqlite-worker'
  config.content_type = 'html'
  config.structured = true
end

require_relative './extensions/hash_extension'
require_relative './version_hook'
require_relative './test_hook'
require_relative './metadata_hook'
require_relative './checker'
require_relative './multiple_executions_runner'
require_relative './html_renderer'
require_relative './dataset'
require_relative './dataset_solution_parser'
require_relative './query_solution_parser'
require_relative './errors'
