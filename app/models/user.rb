# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  mobile_phone           :string
#  gender                 :string
#  avatar                 :string
#  uid                    :string
#  slug                   :string
#  token                  :string
#  name                   :string
#

class User < ApplicationRecord
  include UniqueID
  include UserToken
  include UserChatroom

  extend FriendlyId

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         authentication_keys: [:login]

  attr_accessor :captcha, :login

  MOBILE_REGEX = /(13[0-9]|14[0-9]|17[0-9]|15[0-9]|18[0-9])[0-9]{8}/

  unique_using column: :uid, callback: :before_validation, if: -> (user) { user.new_record? }

  friendly_id :uid, use: [:slugged, :finders]

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(mobile_phone) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.create_wechat_user wechat_session
    nickname = wechat_session.info.nickname

    users_count = User.where(name: nickname).count

    user = User.new
    user.name = "#{wechat_session.info.nickname}#{users_count.zero? ? '' : users_count}"
    user.gender = wechat_session.info.sex
    user.avatar = wechat_session.info.headimgurl
    user.save(validate: false)
    return user
  end

  def email_required?
    false
  end

end
