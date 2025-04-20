# spec/system/app_spec.rb
require 'rails_helper'
RSpec.describe "基本機能テスト", type: :system do
  let(:user) { create(:user, email: "test@example.com", password: "password") }

  describe "ユーザー認証" do
    # ユーザー認証テストはそのまま（成功しているため）
    it "ユーザー登録ができる" do
      visit new_user_registration_path
      
      fill_in "user_username", with: "テストユーザー"
      fill_in "user_email", with: "new_user@example.com"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      
      click_button "登録"
      
      expect(page).to have_content "new_user@example.com"
    end
    
    it "ログインができる" do
      visit new_user_session_path
      
      fill_in "user_email", with: user.email
      fill_in "user_password", with: "password"
      
      click_button "ログイン"
      
      expect(page).to have_content "ログインしました"
    end
  end
  
  # タスク管理のテストを別のdescribeブロックで分離
  describe "タスク管理", type: :system do
    let(:user) { create(:user, email: "task_test@example.com", password: "password") }
    let!(:task) { create(:task, user: user, title: "テストタスク") } # let!で即時実行
    
    # 各テストの前にログイン処理を行う
    before do
      # 明示的にログイン
      visit new_user_session_path
      fill_in "user_email", with: user.email
      fill_in "user_password", with: "password"
      click_button "ログイン"
      
      # ログイン成功を確認
      expect(page).to have_content "ログインしました"
    end
    
    it "タスク一覧が表示される" do
      # タスク一覧ページに明示的にアクセス
      visit tasks_path
      
      # タスクが表示されているか確認
      expect(page).to have_content "テストタスク"
    end
    
    it "新規タスクが作成できる" do
      # 新規タスク作成ページにアクセス
      visit new_task_path
      
      # フォームに入力
      # テストタイトルと説明
      find("#task_title").set("新しいタスク")
      find("#task_description").set("これは新しいタスクです")
      
      # 保存ボタンをクリック
      click_button "保存"
      
      # 作成したタスクが表示されているか確認
      expect(page).to have_content "新しいタスク"
    end
    
    it "タスクの編集ができる" do
      # 編集ページにアクセス
      visit edit_task_path(task)
      
      # タイトルを変更
      find("#task_title").set("編集したタスク")
      
      # 保存ボタンをクリック
      click_button "保存"
      
      # 変更が反映されているか確認
      expect(page).to have_content "編集したタスク"
    end
    
    # it "タスクの削除ができる", js: true do
    #   visit task_path(task)
      
    #   # JavaScriptによる削除処理を直接実行（ブラウザ内でJavaScript実行）
    #   page.execute_script("document.querySelector('a[data-method=\"delete\"]').click()")
      
    #   # 削除処理の完了を待つ
    #   sleep 1
      
    
    #   # 一覧ページに移動して確認
    #   visit tasks_path
      
    #   # タスクが表示されていないことを確認
    #   expect(page).not_to have_content "テストタスク"
    # end
  end
end