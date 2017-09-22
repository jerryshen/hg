class HomeController < ApplicationController
  before_action :set_chatroom

  def index
    @main_nav = :home
  end

  def basketball
    @main_nav = :basketball
  end

  def baseball
    @main_nav = :baseball
  end

  def soccer
    @main_nav = :soccer
  end

  def set_chatroom
    @chatroom = true
  end

  # def on_open
  #   return close unless params['id']
  #   @name = params['id']
  #   subscribe channel: "chat"
  #   publish channel: "chat", message: "#{@name} joind the chat."
  #   write "Welcome, #{@name}!"
  # end
  # def on_close
  #   publish channel: "chat", message: "#{@name} joind the chat."
  # end
  # def on_message data
  #   publish channel: "chat", message: "#{@name}: #{data}"
  # end

  # Websocket / AJA

end