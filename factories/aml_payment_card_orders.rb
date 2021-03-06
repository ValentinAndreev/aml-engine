FactoryBot.define do
  factory(:aml_payment_card_order, class: AML::PaymentCardOrder) do
    card_brand { 'VISA' }
    card_bin { '1234' }
    card_suffix { '5678' }
    association :client, factory: :aml_client
    association :operator, factory: [:aml_operator, :administrator]

    trait :rejected do
      workflow_state { :rejected }
      association :aml_reject_reason
    end
  end
end
