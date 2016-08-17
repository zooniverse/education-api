class DownloadsController < ApplicationController
  # This exists because Safari is not able to let client-side JS emit a file that gets "downloaded".
  #
  def create
    send_data params[:data], type: params[:content_type], filename: params[:filename], disposition: 'attachment'
  end

  def require_login
    true
  end
end