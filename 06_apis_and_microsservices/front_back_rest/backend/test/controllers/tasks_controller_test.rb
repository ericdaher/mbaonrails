require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  class IndexTest < TasksControllerTest
    test "should receive empty body when tasks don't exist" do
      Task.delete_all

      get tasks_url, as: :json

      assert_response :success
      assert_equal response.body, {
        data: []
      }.to_json
    end

    test "should receive tasks in body when tasks exist" do
      @task = tasks(:one)
      
      get tasks_url, as: :json

      assert_response :success
      assert_equal response.body, {
        data: [
          {
            type: "tasks",
            id: @task.id,
            attributes: {
              description: @task.description,
              status: @task.status,
              due_at: @task.due_at
            }
          }
        ]
      }.to_json
    end
  end

  class ShowTest < TasksControllerTest
    test "should return not found when fetching a task that does not exist" do
      Task.delete_all

      get task_url(123_456), as: :json
      assert_response :not_found
    end

    test "should return the task when fetching a task that exists" do
      @task = tasks(:one)

      get task_url(@task.id), as: :json

      assert_response :success
      assert_equal response.body, {
        data: {
          type: "tasks",
          id: @task.id,
          attributes: {
            description: @task.description,
            status: @task.status,
            due_at: @task.due_at
          }
        }
      }.to_json
    end
  end

  class CreateTest < TasksControllerTest
    test "should return bad request with incorrect params" do
      post tasks_url, params: { incorrect_param: "incorrect_param" }

      assert_response :bad_request
    end

    test "should create a task with correct params" do
      Task.delete_all

      post tasks_url, params: { 
        data: {
          type: "tasks",
          attributes: {
            description: "Task de exemplo",
            status: "pending",
            due_at: 1.day.from_now
          }
        }
      }, as: :json

      @task = Task.last
      assert_response :created
      assert_equal response.body, {
        data: {
          type: "tasks",
          id: @task.id,
          attributes: {
            description: @task.description,
            status: @task.status,
            due_at: @task.due_at
          }
        }
      }.to_json
    end
  end

  class UpdateTest < TasksControllerTest
    test "should return bad request with incorrect params" do
      @task = tasks(:one)

      patch task_url(@task.id), params: { incorrect_param: "incorrect_param" }

      assert_response :bad_request
    end

    test "should update a task with correct params" do
      @task = tasks(:one)

      patch task_url(@task.id), params: { 
        data: {
          type: "tasks",
          id: @task.id,
          attributes: {
            description: "Nova descrição",
            status: "pending",
            due_at: 1.day.from_now
          }
        }
      }, as: :json

      @task.reload
      assert_response :success
      assert_equal response.body, {
        data: {
          type: "tasks",
          id: @task.id,
          attributes: {
            description: "Nova descrição",
            status: @task.status,
            due_at: @task.due_at
          }
        }
      }.to_json
    end
  end

  class DeleteTest < TasksControllerTest
    test "should delete a task successfully" do
      @task = tasks(:one)

      delete task_url(@task.id)

      assert_response :success
      assert_nil Task.first
    end
  end
end