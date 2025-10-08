class TasksController < ApplicationController
  def index
    @tasks = Task.all
    puts @tasks
  end

  def new
  end

  def create
    @task = Task.new(description: task_params[:description], status: task_params[:status], due_at: task_params[:due_at])
    if @task.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @task = Task.get(params[:id])
    puts @task
  end

  def update
    @task = Task.new(id: params[:id], description: task_params[:description], status: task_params[:status], due_at: task_params[:due_at])
    if @task.update
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    Task.delete(params[:id])
    redirect_to root_path  
  end

  private

  def task_params
    params.permit(:description, :status, :due_at)
  end
end