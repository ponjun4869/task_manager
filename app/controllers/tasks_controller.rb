class TasksController < ApplicationController
  # ログインしていないユーザーはタスク画面を開けないようにする
  before_action :authenticate_user!

  def index
    # ログイン中のユーザーに紐づくタスクだけを取得する
    @tasks = current_user.tasks

    # 検索キーワードがある場合は、タイトルまたは内容に含まれるタスクを絞り込む
    if params[:q].present?
      @tasks = @tasks.where("title ILIKE ? OR content ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
    end

    # 1ページあたり10件ずつ表示する
    @tasks = @tasks.page(params[:page]).per(10)
  end

  def show
    # 他のユーザーのタスクを見られないように、current_user.tasksから探す
    @task = current_user.tasks.find(params[:id])
  end

  def new
    # ログイン中のユーザーに紐づく新しいタスクを作る
    @task = current_user.tasks.new
  end

  def create
    # フォームから送られた値を使って、ログイン中のユーザーのタスクを作る
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to tasks_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    # 編集対象もログイン中のユーザーのタスクから探す
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
    # 削除対象もログイン中のユーザーのタスクから探す
    @task = current_user.tasks.find(params[:id])
    @task.destroy

    redirect_to  tasks_path
  end

  private

  def task_params
    # フォームから受け取れる項目を制限する
    params.require(:task).permit(:title, :content, :status, :priority, :deadline)
  end
end
