class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = @user.tasks.order(created_at: :desc)
  end

  def show
  end

  def new
    @task = @user.tasks.build
  end

  def create
    @task = @user.tasks.build(task_params)

    if @task.save
      redirect_to user_tasks_path(@user), notice: "タスクが正常に作成されました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to user_tasks_path(@user), notice: "タスクが正常に更新されました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to user_tasks_path(@user), notice: "タスクが正常に削除されました"
  end

  private

  def set_user
    if current_user.admin? && params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
  end

  def set_task
    @task = @user.tasks.find_by(id: params[:id])
    unless @task
      flash[:alert] = "アクセスが拒否されました。そのタスクは存在しないか、アクセス権限がありません。"
      redirect_to user_tasks_path(@user)
    end
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end
