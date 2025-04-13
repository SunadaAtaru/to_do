require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "ユーザー登録" do
    it "登録画面にアクセスできる" do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end

    it "有効なユーザー情報で登録できる" do
      expect {
        post user_registration_path, params: {
          user: {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      }.to change(User, :count).by(1)

      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(response.body).to include("ログアウト").or include("ログインしました").or include("Signed in successfully")
    end
  end

  describe "ログイン機能" do
    let(:user) { create(:user, password: 'password') }

    it "ログインページにアクセスできる" do
      get new_user_session_path
      expect(response).to have_http_status(:success)
    end

    it "正しい情報でログインできる" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: 'password'
        }
      }

      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(response.body).to include("ログアウト").or include("ログインしました").or include("Signed in successfully")
    end
  end

  describe "ログアウト機能" do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it "ログアウトできる" do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)

      follow_redirect!
      expect(response.body).to include("ログイン").or include("ログアウトしました").or include("Signed out successfully")
    end
  end
end
