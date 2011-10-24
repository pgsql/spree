# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{win32-open3-19}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mat Schaffer"]
  s.date = %q{2011-01-13}
  s.email = %q{mat@schaffer.me}
  s.files = ["lib/win32/open3.rb"]
  s.homepage = %q{https://github.com/matschaffer/win32-open3-19}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{nowarning}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Provides Open4.popen4 in Ruby 1.9 on windows}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
