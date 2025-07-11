class Task < ApplicationRecord
  enum :status, [ :ongoing, :overdue, :done, :canceled ]

  validates :title, :description, :status, presence: true

  def overdue_if_after_due_date
    return if due_date.nil?

    overdue if due_date < Date.current
  end
end
