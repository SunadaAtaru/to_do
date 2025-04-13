require 'rails_helper'

RSpec.describe Task, type: :model do
  # テスト全体で再利用するユーザー
  let(:user) { User.create(email: "test@example.com", password: "password") }
  
  describe "バリデーション" do
    it "タイトル、ステータス、ユーザーがあれば有効" do
      task = Task.new(
        title: "テストタスク",
        status: "未完了",
        user: user
      )
      expect(task).to be_valid
    end

    it "タイトルがなければ無効" do
      task = Task.new(title: nil, status: "未完了", user: user)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it "ステータスに不正な値を設定すると無効" do
      task = Task.new(title: "テストタスク", status: "不正な値", user: user)
      expect(task).not_to be_valid
      expect(task.errors).to have_key(:status)
    end

    it "不正なステータスでは無効" do
      task = Task.new(title: "テストタスク", status: "保留中", user: user)
      task.valid?
      expect(task.errors[:status]).to include("is not included in the list")
    end
    
    it "ユーザーがなければ無効" do
      task = Task.new(title: "テストタスク", status: "未完了", user: nil)
      task.valid?
      expect(task.errors[:user]).to include("must exist")
    end
  end

  describe "デフォルト値" do
    it "新規作成時はステータスが未完了になる" do
      task = Task.new(title: "テストタスク", user: user)
      expect(task.status).to eq("未完了")
    end
  end
  
  describe "関連付け" do
    it "ユーザーに属している" do
      task = Task.reflect_on_association(:user)
      expect(task.macro).to eq(:belongs_to)
    end
  end
end