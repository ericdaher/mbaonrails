class Task
  def self.all
    uri = URI('http://back:3000/tasks')
    headers = { 'Content-Type': 'application/json' }
    res = Net::HTTP.get(uri, headers)

    JSON.parse(res)["data"]
  end

  def self.get(id)
    uri = URI("http://back:3000/tasks/#{id}")
    headers = { 'Content-Type': 'application/json' }
    res = Net::HTTP.get(uri, headers)

    JSON.parse(res)["data"]
  end

  def self.delete(id)
    uri = URI("http://back:3000/tasks/#{id}")
    req = Net::HTTP::Delete.new(uri)
    req['Content-Type'] = 'application/json'

    Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
  end

  def initialize(id:, description:, status:, due_at:)
    @id = id
    @description = description
    @status = status
    @due_at = due_at
  end

  def save
    uri = URI('http://back:3000/tasks')
    body = {
      data: {
        type: "tasks",
        attributes: {
          description: @description,
          status: @status,
          due_at: @due_at
        }
      }
    }
    headers = { 'Content-Type': 'application/json' }
    res = Net::HTTP.post(uri, body.to_json, headers)

    JSON.parse(res.body)["data"]
  end

  def update
    uri = URI("http://back:3000/tasks/#{@id}")
    req = Net::HTTP::Patch.new(uri)
    req.body = {
      data: {
        type: "tasks",
        id: @id,
        attributes: {
          description: @description,
          status: @status,
          due_at: @due_at
        }
      }
    }.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    JSON.parse(res.body)["data"]
  end
end