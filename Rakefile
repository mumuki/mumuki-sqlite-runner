require 'rdoc/task'
require 'rspec/core/rake_task'


task default: :spec


RSpec::Core::RakeTask.new(:spec)


RDoc::Task.new do |rdoc|
  rdoc.main = 'README.md'
  rdoc.rdoc_dir = 'docs/rdoc'
  rdoc.rdoc_files.include('README.md', 'lib/*.rb')
end