class ChatroomController < ApplicationController

  def request_addr
    roomid = params[:roomid]  
    uid = params[:uid]

    if cookies[:response].blank?
      response = Chatroom.request_addr uid
      cookies[:response] = response
    else
      response = cookies[:response]
    end

    render json: response.to_json
  end

end
