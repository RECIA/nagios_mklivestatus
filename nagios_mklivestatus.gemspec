Gem::Specification.new do |s| 
  s.name = "nagios_mklivestatus"
  s.description = "Querying Nagios MKLiveStatus through TCP or Unix sockets"
  s.version = "0.0.10"
  s.author = "Esco-lan Team"
  s.email = "team@esco-lan.org"
  s.homepage = "https://github.com/RECIA/nagios_mklivestatus"
  s.platform = Gem::Platform::RUBY
  s.summary = "Querying Nagios MKLiveStatus through sockets TCP or Unix"
  s.files = Dir['lib/**/*.rb'] + Dir['bin/**/*'] + Dir['log/**/*']
  s.bindir = "bin"
  s.executables = ['nagmk-ruby','nagmk-ruby-config']
  s.require_path = "lib"
  s.extra_rdoc_files = ["README.rdoc","RELEASE.rdoc"]
end