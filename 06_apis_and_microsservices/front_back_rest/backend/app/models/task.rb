class Task < ApplicationRecord
  enum :status, [ :pending, :completed, :late ]

  def to_structured_json
    {
      type: "tasks",
      id: id,
      attributes: {
        description: description,
        status: status,
        due_at: due_at
      }
    }
  end
end