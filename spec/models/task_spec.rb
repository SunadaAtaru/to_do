require 'rails_helper'

RSpec.describe Task, type: :model do
  # テスト全体で再利用するユーザー
  let(:user) { create(:user) }
  
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
      # expect(task.errors).to have_key(:title)
      expect(task.errors[:title]).to include("を入力してください")
    end
    

    it "ステータスに不正な値を設定すると無効" do
      task = Task.new(title: "テストタスク", status: "不正な値", user: user)
      expect(task).not_to be_valid
      expect(task.errors).to have_key(:status)
    end

    it "不正なステータスでは無効" do
      task = Task.new(title: "テストタスク", status: "保留中", user: user)
      task.valid?
      # expect(task.errors).to have_key(:status)
      expect(task.errors[:status]).to include("は一覧にありません")
    end
    
    
    it "ユーザーがなければ無効" do
      task = Task.new(title: "テストタスク", status: "未完了", user: nil)
      task.valid?
      expect(task.errors[:user]).to include("を指定してください")
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