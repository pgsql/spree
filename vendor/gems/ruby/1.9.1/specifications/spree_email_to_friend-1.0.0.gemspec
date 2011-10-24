# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{spree_email_to_friend}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jorge Cal\u00C3\u00A1s Lozano, Roman Smirnov"]
  s.date = %q{2010-12-22}
  s.files = ["spec/controllers/email_sender_controller_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.homepage = %q{https://github.com/calas/spree-email-to-friend}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Spree extension to send product recommendations to friends}
  s.test_files = ["spec/controllers/email_sender_controller_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spree_core>, [">= 0.30.1"])
      s.add_runtime_dependency(%q<spree_auth>, [">= 0.30.1"])
      s.add_runtime_dependency(%q<recaptcha>, [">= 0.3.1"])
    else
      s.add_dependency(%q<spree_core>, [">= 0.30.1"])
      s.add_dependency(%q<spree_auth>, [">= 0.30.1"])
      s.add_dependency(%q<recaptcha>, [">= 0.3.1"])
    end
  else
    s.add_dependency(%q<spree_core>, [">= 0.30.1"])
    s.add_dependency(%q<spree_auth>, [">= 0.30.1"])
    s.add_dependency(%q<recaptcha>, [">= 0.3.1"])
  end
end
