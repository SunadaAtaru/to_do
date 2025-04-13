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
  end
end
