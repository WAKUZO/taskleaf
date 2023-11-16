class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page]).per(50)

    # csv出力
    respond_to do |format|
      format.html
      format.csv{send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%D')}.csv"}
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    # 確認画面で戻るを押した場合新規画面に戻る
    if params[:back].present?
      render :new
      return
    end

    if @task.save
      # メールの送信
      TaskMailer.creation_email(@task).deliver_now
      # jobの呼び出し
      SampleJob.perform_later
      redirect_to tasks_url, notice: "タスク #{@task.name}を登録しました"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク #{@task.name}を更新しました"
  end

  def destroy
    @task.destroy
    # ajax
    # head :no_content
    # redirect_to tasks_url, notice: "タスク #{@task.name}を削除しました"
  end

  #登録前の確認画面
  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  # csvインポート
  def import
    current_user.tasks.import(params[:file])
    redirect_to tasks_url, notice: "タスクを追加しました"
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :image)
  end

end
