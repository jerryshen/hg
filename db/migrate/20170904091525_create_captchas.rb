class CreateCaptchas < ActiveRecord::Migration[5.1]
  def change
    create_table :captchas do |t|
      t.string    :mobile_phone
      t.string    :captcha
      t.datetime  :captcha_sent_at

      t.timestamps null: false
    end

    add_index :captchas, :mobile_phone
    add_index :captchas, :captcha
    add_index :captchas, :captcha_sent_at
  end
end
