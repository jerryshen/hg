module ApplicationHelper

  def main_nav(name, options = {}, &block)
    if @main_nav == name
      if options[:class]
        options[:class] += ' active'
      else
        options[:class] = 'active'
      end
    end
    content = capture(&block)
    content_tag(:li, content, options)
  end

  def sec_nav(name, options = {}, &block)
    if @sec_nav == name
      if options[:class]
        options[:class] += ' active'
      else
        options[:class] = 'active'
      end
    end
    content = capture(&block)
    content_tag(:li, content, options)
  end
  
end
