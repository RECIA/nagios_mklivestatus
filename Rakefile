require 'rubygems/package_task'
spec = Gem::Specification.load(Dir['*.gemspec'].first)
gem = Gem::PackageTask.new(spec)
gem.define
desc "Push gem to rubygems.org"
task :push => :gem do
     sh "gem push #{gem.package_dir}/#{gem.gem_file}"
end
