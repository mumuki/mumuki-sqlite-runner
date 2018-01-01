require 'rdoc/task'
require 'rspec/core/rake_task'


task default: :spec


RSpec::Core::RakeTask.new(:spec)


RSpec::Core::RakeTask.new(:test) do |t|
  t.rspec_opts = '--fail-fast'
  t.exclude_pattern = './spec/integration_spec.rb'
end



RDoc::Task.new do |rdoc|
  rdoc.main = 'README.md'
  rdoc.rdoc_dir = 'docs/rdoc'
  rdoc.rdoc_files.include('README.md', 'lib/*.rb')
end