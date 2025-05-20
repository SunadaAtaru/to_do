class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [ :show, :edit, :update, :destroy, :toggle_status ]

  # GET /tasks
  def index
    @tasks = current_user.tasks.order(created_at: :desc)
  end

  # GET /tasks/:id
  def show
  end

  # GET /tasks/new
  def new
    @task = current_user.tasks.build
  end

  # POST /tasks
  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      redirect_to tasks_path, notice: "タスクが正常に作成されました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /tasks/:id/edit
  def edit
  end

  # PATCH/PUT /tasks/:id
  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクが正常に更新されました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_status
    if @task.status == "完了"
      @task.update(status: "未完了")
    else
      @task.update(status: "完了")
    end

    redirect_to tasks_path, notice: "タスクの状態を更新しました"
  end


  # DELETE /tasks/:id
  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "タスクが正常に削除されました"
  end

  private

  # タスクの取得と認可
  def set_task
    @task = current_user.tasks.find_by(id: params[:id])

    unless @task
      flash[:alert] = "アクセスが拒否されました。そのタスクは存在しないか、アクセス権限がありません。"
      redirect_to tasks_path
      nil
    end
  end

  # Strong Parameters
  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end
