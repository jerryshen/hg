class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout proc { |controller| controller.request.xhr? ? false : 'application' }

  before_action :get_user

  def get_user
    if @chatroom == true
      if user_signed_in?
        user = current_user

        cookies[:uid] = user.uid
        cookies[:sdktoken] = user.token
        cookies[:nickName] = user.name
      else
        # user = User.find_by mobile_phone: '18600000000'
        uid = User.first._gen_uid_value
        NeteaseIM::User.create(accid: uid.to_s, name: "游客#{uid}", token: token.to_s)
        token = uid

        cookies[:uid] = uid
        cookies[:sdktoken] = token
        cookies[:nickName] = nil
      end

      cookies[:roomid] = Chatroom::ROOMID
    end
  end

  class << self
    def main_nav_highlight(name)
      before_action { |c| c.instance_variable_set(:@main_nav, name) }
    end

    def sec_nav_highlight(name)
      before_action { |c| c.instance_variable_set(:@sec_nav, name) }
    end
  end
end
