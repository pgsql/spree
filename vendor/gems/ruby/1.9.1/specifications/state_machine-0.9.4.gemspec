# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{state_machine}
  s.version = "0.9.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Pfeifer"]
  s.date = %q{2010-08-01}
  s.description = %q{Adds support for creating state machines for attributes on any Ruby class}
  s.email = %q{aaron@pluginaweek.org}
  s.files = ["test/unit/callback_test.rb", "test/unit/transition_test.rb", "test/unit/machine_test.rb", "test/unit/event_test.rb", "test/unit/event_collection_test.rb", "test/unit/invalid_transition_test.rb", "test/unit/state_collection_test.rb", "test/unit/invalid_event_test.rb", "test/unit/assertions_test.rb", "test/unit/integrations_test.rb", "test/unit/transition_collection_test.rb", "test/unit/guard_test.rb", "test/unit/eval_helpers_test.rb", "test/unit/integrations/mongo_mapper_test.rb", "test/unit/integrations/data_mapper_test.rb", "test/unit/integrations/sequel_test.rb", "test/unit/integrations/active_model_test.rb", "test/unit/integrations/active_record_test.rb", "test/unit/matcher_test.rb", "test/unit/node_collection_test.rb", "test/unit/matcher_helpers_test.rb", "test/unit/state_test.rb", "test/unit/machine_collection_test.rb", "test/unit/state_machine_test.rb", "test/unit/condition_proxy_test.rb", "test/functional/state_machine_test.rb"]
  s.homepage = %q{http://www.pluginaweek.org}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{pluginaweek}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Adds support for creating state machines for attributes on any Ruby class}
  s.test_files = ["test/unit/callback_test.rb", "test/unit/transition_test.rb", "test/unit/machine_test.rb", "test/unit/event_test.rb", "test/unit/event_collection_test.rb", "test/unit/invalid_transition_test.rb", "test/unit/state_collection_test.rb", "test/unit/invalid_event_test.rb", "test/unit/assertions_test.rb", "test/unit/integrations_test.rb", "test/unit/transition_collection_test.rb", "test/unit/guard_test.rb", "test/unit/eval_helpers_test.rb", "test/unit/integrations/mongo_mapper_test.rb", "test/unit/integrations/data_mapper_test.rb", "test/unit/integrations/sequel_test.rb", "test/unit/integrations/active_model_test.rb", "test/unit/integrations/active_record_test.rb", "test/unit/matcher_test.rb", "test/unit/node_collection_test.rb", "test/unit/matcher_helpers_test.rb", "test/unit/state_test.rb", "test/unit/machine_collection_test.rb", "test/unit/state_machine_test.rb", "test/unit/condition_proxy_test.rb", "test/functional/state_machine_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
