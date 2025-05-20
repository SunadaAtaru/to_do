require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  # let(:user) { User.create!(email: "user@example.com", password: "password") }
  # let(:other_user) { User.create!(email: "other@example.com", password: "password") }
  # let(:valid_attributes) { { title: "テストタスク", description: "詳細内容", status: "未完了" } }
  # let(:invalid_attributes) { { title: "", status: "未完了" } }


  let(:user) { create(:user, email: "user@example.com") }
  let(:other_user) { create(:user, email: "other@example.com") }
  let(:valid_attributes) { attributes_for(:task, title: "テストタスク", description: "詳細内容") }
  let(:invalid_attributes) { attributes_for(:task, title: "") }


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
  # 既存のテストはそのまま

  # 追加テスト
  describe "POST /tasks" do
    context "無効なパラメータの場合" do
      it "タスクが作成されないこと" do
        expect {
          post tasks_path, params: { task: invalid_attributes }
        }.not_to change(Task, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /tasks/:id" do
    context "無効なパラメータの場合" do
      it "タスクが更新されないこと" do
        task = Task.create!(valid_attributes.merge(user: user))
        original_title = task.title

        patch task_path(task), params: { task: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        task.reload
        expect(task.title).to eq(original_title)
      end
    end
  end

  describe "期限日パラメータの処理" do
    it "期限日を含むタスクを作成できること" do
      expect {
        post tasks_path, params: { task: valid_attributes.merge(due_date: Date.tomorrow) }
      }.to change(Task, :count).by(1)

      expect(Task.last.due_date).to eq(Date.tomorrow)
    end

    it "期限日つきのタスクを更新できること" do
      task = Task.create!(valid_attributes.merge(user: user))
      new_date = Date.tomorrow + 7.days

      patch task_path(task), params: { task: { due_date: new_date } }

      task.reload
      expect(task.due_date).to eq(new_date)
    end
  end

  describe "ソート順" do
    it "タスクが作成日の降順で表示されること" do
      # old_task = Task.create!(title: "古いタスク", user: user, created_at: 2.days.ago)
      # new_task = Task.create!(title: "新しいタスク", user: user, created_at: 1.day.ago)
      create(:task, title: "古いタスク", user: user, created_at: 2.days.ago)
      create(:task, title: "新しいタスク", user: user, created_at: 1.day.ago)


      get tasks_path

      expect(response.body.index("新しいタスク")).to be < response.body.index("古いタスク")
    end
  end

  describe "認証" do
    context "未ログインユーザー" do
      before do
        sign_out user
      end

      it "タスク一覧ページにアクセスするとリダイレクトされる" do
        get tasks_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "タスク作成ページにアクセスするとリダイレクトされる" do
        get new_task_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "タスク作成時にリダイレクトされる" do
        post tasks_path, params: { task: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end

      it "タスク詳細ページにアクセスするとリダイレクトされる" do
        task = Task.create!(valid_attributes.merge(user: user))
        get task_path(task)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "フラッシュメッセージ" do
    it "タスク作成時に成功メッセージが表示される" do
      post tasks_path, params: { task: valid_attributes }
      follow_redirect!
      expect(response.body).to include('タスクが正常に作成されました')
    end

    it "タスク更新時に成功メッセージが表示される" do
      task = Task.create!(valid_attributes.merge(user: user))
      patch task_path(task), params: { task: { title: "更新されたタイトル" } }
      follow_redirect!
      expect(response.body).to include('タスクが正常に更新されました')
    end

    it "タスク削除時に成功メッセージが表示される" do
      task = Task.create!(valid_attributes.merge(user: user))
      delete task_path(task)
      follow_redirect!
      expect(response.body).to include('タスクが正常に削除されました')
    end

    it "他のユーザーのタスクにアクセスしようとするとエラーメッセージが表示される" do
      other_task = Task.create!(valid_attributes.merge(user: other_user))
      get task_path(other_task)
      follow_redirect!
      expect(response.body).to include('アクセスが拒否されました')
    end
  end

  describe "存在しないタスクへのアクセス" do
    it "存在しないタスクにアクセスするとリダイレクトされる" do
      get task_path(999999)
      expect(response).to redirect_to(tasks_path)
      follow_redirect!
      expect(response.body).to include('アクセスが拒否されました')
    end
  end
end
