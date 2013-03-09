
FactoryGirl.define do
  sequence(:title) {|n| "Exercise #{n}" }

  factory :exercise do
    title

    ignore do
      sentences_count 2
    end

    after(:create) do |exercise, evaluator|
      user = FactoryGirl.create :user
      FactoryGirl.create_list(:sentence, evaluator.sentences_count, exercise: exercise)
      FactoryGirl.create_list(:sentence, evaluator.sentences_count, exercise: exercise, owner: user)
      FactoryGirl.create_list(:correction, evaluator.sentences_count, exercise: exercise, owner: user)
    end
  end
end
