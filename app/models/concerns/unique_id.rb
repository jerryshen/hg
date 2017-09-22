module UniqueID
  extend ActiveSupport::Concern

  module ClassMethods
    def unique_using(options = {})
      column          = options.fetch :column
      callback        = options.fetch :callback

      class_eval <<-RUBY, __FILE__, __LINE__+1
        #{callback} :gen_#{column}

        def gen_#{column}
          _id = nil
          if _gen_#{column}_if(self)
            loop do
              _id = _gen_#{column}_value.to_s
              break unless self.class.exists?(#{column}: _id)
            end

            _gen_#{column}_after(self, #{column}, _id)
          end
        end

      RUBY

      class_eval do
        define_method "_gen_#{column}_value" do
          # 2147483647 是pg的integer限制，超过这个数字User.find_by(id: xxx)将会报错
          generator = options.fetch :generator, -> { SecureRandom.random_number(2147483646) }
          generator.call
        end

        define_method "_gen_#{column}_if".to_sym do |obj|
          if_callback = options.fetch :if, nil
          if if_callback
            if_callback.call obj
          else
            true
          end
        end

        define_method "_gen_#{column}_after".to_sym do |obj, _column, value|
          after_generator = options.fetch :after_generator, nil
          if after_generator
            after_generator.call obj, column, value
          else
            obj.send "#{column}=", value
          end
        end
      end
    end
  end
end
