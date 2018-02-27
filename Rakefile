require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

desc "Uninstall gitsync gem from system gems"
task :uninstall do
  system 'gem uninstall gitsync'
end

task :default => :test
