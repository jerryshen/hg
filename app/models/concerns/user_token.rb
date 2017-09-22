module UserToken
  extend ActiveSupport::Concern

  included do
    before_save :ensure_authentication_token
  end

  def ensure_authentication_token
    if token.blank?
      self.token = generate_authentication_token
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(token: token).first
    end
  end

end
