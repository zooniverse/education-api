class KinesisController < ApplicationController
  def create
    Kinesis::Create.run!(params)
    render :nothing
  end

  def require_login
    true
  end
end
