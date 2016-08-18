class KinesisController < ApplicationController
  def create
    Kinesis::Create.run!(params)
    head :no_content
  end

  def require_login
    true
  end
end
