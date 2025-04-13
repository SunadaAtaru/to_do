# spec/models/task_spec.rb
require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "バリデーション" do
    it "タイトル、ステータス、ユーザーがあれば有効" do
      user = User.create(email: "test@example.com", password: "password")
      task = Task.new(
        title: "テストタスク",
        status: "未完了",
        user: user
      )
      expect(task).to be_valid
    end

    it "タイトルがなければ無効" do
      task = Task.new(title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it "不正なステータスでは無効" do
      task = Task.new(status: "保留中")
      task.valid?
      expect(task.errors[:status]).to include("is not included in the list")
    end
  end

  describe "デフォルト値" do
    it "新規作成時はステータスが未完了になる" do
      task = Task.new
      expect(task.status).to eq("未完了")
    end
  end
end