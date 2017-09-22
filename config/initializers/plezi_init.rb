require 'plezi'
class ChatServer
  @auto_dispatch = true

  def chat_auth event
    if params[:nickname] || (::ERB::Util.h(event[:nickname]) == "Me")
      # Not allowed (double authentication / reserved name)
      close
      return
    end
    # set our ID and subscribe to the chatroom's channel
    params[:nickname] = ::ERB::Util.h event[:nickname]
    subscribe channel: :chat
    # publish the new client's presence.
    publish channel: :chat, message: {event: 'chat_login',
                           name: params[:nickname],
                           user_id: id}.to_json
    # if we return an object, it will be sent to the websocket client.
    nil
  end
  def chat_message msg
    # prevent false identification
    msg[:name] = params[:nickname]
    msg[:user_id] = id
    # publish the chat message
    publish channel: :chat, message: msg.to_json
    nil
  end
  def on_close
    # inform about client leaving the chatroom
    publish channel: :chat, message: {event: 'chat_logout',
                           name: params[:nickname],
                           user_id: id}.to_json
  end

end
# setup route to html/javascript client
# Plezi.templates = Root.join('views').to_s

# connect route to controller
Plezi.route '/ws', ChatServer