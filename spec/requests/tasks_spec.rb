require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:user) { User.create!(email: "user@example.com", password: "password") }
  
  before do
    sign_in user  # Deviseのヘルパーメソッド
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
end