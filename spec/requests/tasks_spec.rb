require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:user) { User.create!(email: "user@example.com", password: "password") }
  let(:other_user) { User.create!(email: "other@example.com", password: "password") }

  before do
    sign_in user  # Deviseのサインインヘルパー
  end

  describe "GET /tasks" do
    it "一覧ページが表示されること" do
      get tasks_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /tasks/:id" do
    it "詳細ページが表示されること" do
      task = Task.create!(title: "テストタスク", user: user)
      get task_path(task)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /tasks/new" do
    it "新規作成ページが表示されること" do
      get new_task_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /tasks" do
    it "新しいタスクが作成されること" do
      expect {
        post tasks_path, params: { task: { title: "新しいタスク" } }
      }.to change(Task, :count).by(1)
      
      expect(response).to redirect_to(tasks_path)
    end
  end

  describe "GET /tasks/:id/edit" do
    it "編集ページが表示されること" do
      task = Task.create!(title: "テストタスク", user: user)
      get edit_task_path(task)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /tasks/:id" do
    it "タスクが更新されること" do
      task = Task.create!(title: "古いタイトル", user: user)
      patch task_path(task), params: { task: { title: "新しいタイトル" } }
      
      expect(response).to redirect_to(tasks_path)
      task.reload
      expect(task.title).to eq("新しいタイトル")
    end
  end

  describe "DELETE /tasks/:id" do
    it "タスクが削除されること" do
      task = Task.create!(title: "削除するタスク", user: user)
      
      expect {
        delete task_path(task)
      }.to change(Task, :count).by(-1)
      
      expect(response).to redirect_to(tasks_path)
    end
  end

  # 認可のテスト
  describe "認可" do
    it "他のユーザーのタスク詳細ページにアクセスするとリダイレクトされる" do
      other_task = Task.create!(title: "他のユーザーのタスク", user: other_user)
      get task_path(other_task)

      expect(response).to redirect_to(tasks_path)
      follow_redirect!
      expect(response.body).to include("アクセスが拒否されました")
    end

    it "他のユーザーのタスク編集ページにアクセスするとリダイレクトされる" do
      other_task = Task.create!(title: "他のユーザーのタスク", user: other_user)
      get edit_task_path(other_task)

      expect(response).to redirect_to(tasks_path)
    end

    it "他のユーザーのタスクを更新しようとするとリダイレクトされる" do
      other_task = Task.create!(title: "他のユーザーのタスク", user: other_user)
      patch task_path(other_task), params: { task: { title: "更新しようとしたタイトル" } }

      expect(response).to redirect_to(tasks_path)
      other_task.reload
      expect(other_task.title).to eq("他のユーザーのタスク")
    end

    it "他のユーザーのタスクを削除しようとするとリダイレクトされる" do
      other_task = Task.create!(title: "他のユーザーのタスク", user: other_user)

      expect {
        delete task_path(other_task)
      }.not_to change(Task, :count)

      expect(response).to redirect_to(tasks_path)
    end
  end

  # toggle_statusアクションのテスト
describe "PATCH /tasks/:id/toggle_status" do
  it "タスクの状態を未完了から完了に切り替えられる" do
    task = Task.create!(title: "テストタスク", status: "未完了", user: user)
    
    patch toggle_status_task_path(task)
    
    expect(response).to redirect_to(tasks_path)
    task.reload
    expect(task.status).to eq("完了")
  end
  
  it "タスクの状態を完了から未完了に切り替えられる" do
    task = Task.create!(title: "テストタスク", status: "完了", user: user)
    
    patch toggle_status_task_path(task)
    
    expect(response).to redirect_to(tasks_path)
    task.reload
    expect(task.status).to eq("未完了")
  end
  
  it "他のユーザーのタスクの状態は変更できない" do
    other_task = Task.create!(title: "他のユーザーのタスク", status: "未完了", user: other_user)
    
    patch toggle_status_task_path(other_task)
    
    expect(response).to redirect_to(tasks_path)
    other_task.reload
    expect(other_task.status).to eq("未完了") # 変更されていないことを確認
  end
 end
end
