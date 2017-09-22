## Sms.new.send('18616386885')

class Sms
  USERNAME = 'hg@sephplus.com'
  PASSWORD = '54bea14b3ae55c857263197d74b09d08'

  def get_verify_code phone
    Captcha.expired.destroy_all

    loop do
      code = rand(100000..999999)
      return code if Captcha.where(mobile_phone: phone, captcha: code.to_s).blank?
    end
  end

  def send phone, options={}
    var_code phone, 1867438
  end

  private

  def var_code phone, tpl_id
    code                    = get_verify_code(phone)
    captcha                 = Captcha.find_or_initialize_by(mobile_phone: phone)
    captcha.captcha         = code
    captcha.captcha_sent_at = Time.zone.now

    if captcha.save
      ChinaSMS.use :yunpian, username: USERNAME, password: PASSWORD
      tpl_params = { code: code }
      ChinaSMS.to phone, tpl_params, tpl_id: tpl_id
    end
  end
end
