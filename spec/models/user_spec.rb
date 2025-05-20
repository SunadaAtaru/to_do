# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションの確認' do
    it '有効なユーザーは保存される' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'メールが空だと無効' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'パスワードが6文字未満だと無効' do
      user = build(:user, password: '12345', password_confirmation: '12345')
      expect(user).not_to be_valid
    end

    it 'パスワードと確認用パスワードが一致しないと無効' do
      user = build(:user, password: 'password123', password_confirmation: 'wrong')
      expect(user).not_to be_valid
    end

    # 一意性のテストを追加
    it '同じメールアドレスのユーザーは登録できない' do
      create(:user, email: 'duplicate@example.com')
      user = build(:user, email: 'duplicate@example.com')
      expect(user).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'タスクを複数持つことができる' do
      user = create(:user)
      create_list(:task, 3, user: user)
      expect(user.tasks.count).to eq(3)
    end

    it 'ユーザーが削除されると関連するタスクも削除される' do
      user = create(:user)
      create(:task, user: user)
      expect { user.destroy }.to change(Task, :count).by(-1)
    end
  end
end
