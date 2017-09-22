# == Schema Information
#
# Table name: captchas
#
#  id              :integer          not null, primary key
#  mobile_phone    :string
#  captcha         :string
#  captcha_sent_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Captcha < ApplicationRecord

  scope :expired, -> {where('captcha_sent_at < ?', 10.minutes.ago)}

  def expired?
    self.captcha_sent_at < 10.minutes.ago
  end

  def self.match mobile_phone, captcha
    capt = Captcha.find_by mobile_phone: mobile_phone, captcha: captcha.to_s
    if capt.present? && !capt.expired?
      true
    else
      false
    end
  end
  
end
