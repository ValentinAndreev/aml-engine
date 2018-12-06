module AML
  class OrderAuthorizer < ApplicationAuthorizer
    EVENTS = %i[done start accept reject cancel].freeze
    OWNER_REQUIRED_FOR_EVENTS = %i[accept reject cancel].freeze

    def self.readable_by?(_user)
      true
    end

    EVENTS.each do |event|
      ability = Authority.abilities[event] || raise("No ability for event #{event}")
      define_singleton_method "#{ability}_by?" do |_operator|
        true
      end
    end

    EVENTS.each do |event|
      ability = Authority.abilities[event] || raise("No ability for event #{event}")
      define_method "#{ability}_by?" do |operator|
        resource.enabled_workflow_events.include?(event) \
          && (OWNER_REQUIRED_FOR_EVENTS.exclude?(event) || operator.administrator? || resource.is_owner?(operator))
      end
    end
  end
end
