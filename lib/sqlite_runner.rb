require 'mumukit'
require 'erb'

I18n.load_translations_path File.join(__dir__, 'locales', '*.yml')

Mumukit.runner_name = 'sqlite'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-sqlite-worker:3'
  config.content_type = 'html'
  config.structured = true
end

require_relative './version_hook'
require_relative './test_hook'
require_relative './metadata_hook'
require_relative './checker'
require_relative './multiple_executions_runner'
require_relative './html_renderer'
require_relative './dataset'
require_relative './parsers/common_test_parser'
require_relative './parsers/query_test_parser'
require_relative './parsers/dataset_test_parser'
require_relative './parsers/final_dataset_test_parser'
require_relative './parsers/invalid_test_parser'
require_relative './errors'
