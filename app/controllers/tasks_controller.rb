class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = current_user.tasks

    if params[:q].present?
      @tasks = @tasks.where("title ILIKE ? OR content ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
    end
  end

  def show
    @task = current_user.tasks.find(params[:id])
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to tasks_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def update
    @task = current_user.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to  tasks_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy

    redirect_to  tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :content, :status, :priority)
  end
end
