class TasksController < ApplicationController
  def index
    @tasks = Task.all
    render json: { data: @tasks.map(&:to_structured_json)}, status: :ok
  end

  def show
    @task = Task.find(params[:id])
    if @task
      render json: { data: @task.to_structured_json }, status: :ok      
    else
      render json: {}, status: :not_found
    end
  end

  def create
    @task = Task.new(task_params[:attributes])
    if @task.save
      render json: { data: @task.to_structured_json }, status: :created
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def update
    @task = Task.find(task_params[:id])

    if @task.update(task_params[:attributes])
      render json: { data: @task.to_structured_json }, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end    
  end

  def destroy
    @task = Task.find(params[:id])

    @task.destroy
  end

  private

  def task_params
    params.require(:data).permit(:type, :id, attributes: [ :description, :status, :due_at ])
  end
end