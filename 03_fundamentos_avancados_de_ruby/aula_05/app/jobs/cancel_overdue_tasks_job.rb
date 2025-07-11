class CancelOverdueTasksJob < ApplicationJob
  def perform
    Task.find_each(&:overdue_if_after_due_date)
  end
end
