class HomeController < ApplicationController
  def index
    render json: "Hello world!", status: :ok
  end
end
