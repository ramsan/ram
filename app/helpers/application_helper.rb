module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
  
  def notification_link(notification_bit)
    state = current_user.notify?(notification_bit) ? 'off' : 'on'
    link_to 'Turn ' + state, '#', :class => 'btn_' + state, 'data-notification-type' => notification_bit
  end
  
  def preference_link(system_bit)
    state = current_user.prefers?(system_bit) ? 'off' : 'on'
    link_to 'Turn ' + state, '#', :class => 'btn_' + state, 'data-preference-type' => system_bit
  end
  
  def comment_link(comment_bit)
    state = current_user.comment_prefers?(comment_bit) ? 'off' : 'on'
    link_to 'Turn ' + state, '#', :class => 'btn_' + state, 'data-comment-type' => comment_bit
  end
  
  def column_div_number(columns, total_elements, element_number, order = 'vertical')
    if order.eql?('vertical')
      per_column = (total_elements.to_f / columns.to_f).ceil
      (element_number.to_f / per_column.to_f).ceil #current_column
    elsif order.eql?('horizontal')
      mod = element_number % columns
      mod.eql?(0) ? columns : mod
    end
  end
  
  def image_source_js_map(memory)
    hsh = {}
    memory.images.select{|i| !i.google_page_url.blank?}.each do |i|
      hsh[i.google_main] = i.google_page_url
    end
    hsh.to_json
  end
  
  def dyr_title(text)
    if text.split.size >= 2
      part1 = text.split(' ').first.capitalize
      part2 = text.split(' ', 2).last
      text = part1 + " " + part2
    else
      text.capitalize
    end
  end

  def dyr_categories_title(text)
    if !text.include?("TV")
      text.titleize
    else
      part1 = text.split(' ').first
      part2 = text.split(' ', 2).last.titleize
      text = part1 + " " + part2
    end
  end

  #Formatting text
  def markdown(text)
    require 'redcarpet'
    renderer = Redcarpet::Render::HTML.new
    extensions = {:smarty_html => true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    (redcarpet.render text).html_safe
  end

  def get_fb_image(url)
    dirty = %x{curl -I #{url + "?type=large"}}
    clean1 = dirty.split('Location: ').last
    image = clean1.split("\r").first
    return image
  end

end
