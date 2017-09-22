class Users::RegistrationsController < Devise::RegistrationsController

  def send_sms
    if (params[:mobile_phone] =~ User::MOBILE_REGEX)!=0
      render json: {error: 'mobile_phone_incorrect'}
    elsif User.find_by(mobile_phone: params[:mobile_phone])
      render json: {error: 'mobile_phone_exist'}
    else
      phone = params[:mobile_phone]
      begin
        type = (params[:type] || 1).to_i
        if params[:_rucaptcha].blank?
          render json: { error: true, msg: '验证码不能为空', field: :captcha}
        else
          if verify_rucaptcha?
            Sms.new.send(phone, type)
            render json: { success: true }
          else
            render json: { error: true, msg: '验证码错误', field: :captcha}
          end
        end
      rescue Exception => e
        render json: { error: true, msg: e.message }
      end
    end
  end

  protected

  def update_resource(resource, params)
    if params[:current_password].present? or params[:password].present? \
      or params[:password_confirmation].present?
      super
    else
      resource.update_without_password(params)
    end
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
