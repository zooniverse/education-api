class KinesisController < ApplicationController
  def create
    Kinesis::Create.run!(params)
    render :nothing
  end
end
