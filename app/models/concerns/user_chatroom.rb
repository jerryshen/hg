module UserChatroom
  extend ActiveSupport::Concern

  included do
    after_create :create_im_user
  end

  def self.creator
    User.find_by mobile_phone: '18616386885'
  end

  def create_im_user
    NeteaseIM::User.create(accid: uid, name: name, token: token)
  end

  def block!
    NeteaseIM::User.block(accid: uid)
  end

  def unblock!
    NeteaseIM::User.unblock(accid: uid)
  end

  def set_member_role
    options = {
      roomid: Chatroom::ROOMID,
      operator: UserChatroom.creator.try(:uid),
      target: uid,
      opt: 2,
      optvalue: true
    }
    NeteaseIM::ChatRoom.set_member_role options
  end
end