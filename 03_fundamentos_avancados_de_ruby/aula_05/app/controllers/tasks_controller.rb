class TasksController < ApplicationController
  def index
    @tasks = Task.all

    @tasks = @tasks.send(params[:status]) if params[:status].present?
    @tasks = @tasks.where("title LIKE ?", "%" + Task.sanitize_sql_like(params[:title]) + "%") if params[:title].present?
    @tasks = @tasks.where("description LIKE ?", "%" + Task.sanitize_sql_like(params[:description]) + "%") if params[:description].present?
    @tasks = @tasks.where(date: params[:date]) if params[:date].present?
    @tasks = @tasks.where(created_at: params[:created_at]) if params[:created_at].present?

    render json: @tasks.to_json, head: :ok
  end

  def show
    @task = Task.find(params[:id])
    render json: @task.to_json, head: :ok
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      render json: @task.to_json, head: :created
    else
      render json: { errors: @task.errors.full_messages }, head: :unprocessable_entity
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      render json: @task.to_json, head: :ok
    else
      render json: { errors: @task.errors.full_messages }, head: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.update(status: "canceled")
      render json: @task.to_json, head: :ok
    else
      render json: { errors: @task.errors.full_messages }, head: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end
