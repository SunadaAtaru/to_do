class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
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
      redirect_to tasks_path, notice: 'タスクが正常に作成されました'
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
      redirect_to tasks_path, notice: 'タスクが正常に更新されました'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  # DELETE /tasks/:id
  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'タスクが正常に削除されました'
  end
  
  private
  
  # タスクの取得と認可
  def set_task
    @task = current_user.tasks.find_by(id: params[:id])
    redirect_to tasks_path, alert: '権限がありません' unless @task
  end
  
  # Strong Parameters
  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end