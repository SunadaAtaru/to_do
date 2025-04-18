# spec/factories/tasks.rb
FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "サンプルタスク#{n}" }
    description { "これはテスト用のタスクです" }
    status { "未完了" }
    association :user
  end
end