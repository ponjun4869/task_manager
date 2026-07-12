FactoryBot.define do
  factory :task do
    title { "RSpecの勉強" }
    content { "モデルテストを書く" }
    status { :not_started }
    priority { :medium }
    association :user
  end
end
