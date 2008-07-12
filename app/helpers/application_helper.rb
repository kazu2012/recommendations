# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def tag_link(tagging)
    link_to(tagging.tag_text, tag_path(tagging.tag.name), {:rel => "tag"})
  end
  
  def user_link(user)
    link_to(user.username, user_path(user.username))
  end

  def cancel_link_to(path, text = "Cancel") 
    link_to(text, path, {:class => "cancel"})
  end

  def title(text)
    content_tag("h1", text)
  end

  def resource_title(entity, resource_path = nil)
    
    if resource_path
      text = link_to_unless_current(x(entity.name), resource_path)
    else 
      text = entity.name
    end
    
    title(text)
  end
  
  def editable_resource_title(entity, resource_path = nil)
    editable_text(content_tag("h1",x(entity.name)), "Rename", nil, resource_path)
  end
  
  def editable_text(text, edit_label = 'Edit', editable_path = nil, text_link_path = nil)
    
    if editable_path == nil
      editable_path = url_for(:action => "edit")
    end
    
    edit_info = content_tag("div", link_to(edit_label, editable_path), :class => "edit_info")
        
    if text_link_path
      text = link_to_unless_current(text, text_link_path)
    end    
        
    field = content_tag("div", text, :class => "field")
    
    return content_tag("div",edit_info + field, :class => "editable_field")
    
  end  
  
  def description_format(text)
    paragraph_format(auto_link_phone_numbers(auto_link(h(text))))
  end
  
  def paragraph_format(text)
    content_tag("p", text.to_s.
      gsub(/\r\n?/, "\n").                    # \r\n and \r -> \n
      gsub(/([^\n])\n([^\n])/, '\1 \2').      # Remove carriage returns
      gsub(/\n\n+/, "</p>\n\n<p>"))           # 2+ newline  -> paragraph
  end  
  
  def auto_link_phone_numbers(text)
    text.gsub(/(\s|^)((0|\+44)\d{10,10})\b/) do 
      text = $1 + "<a href=\"tel:" + $2 + "\">" + $2 + "</a>"
    end
  end
  
  def link_to_content(name)
    link_to(name, "#body", {:class => "skip_navigation", :accesskey => "2"})
  end
  
  def list_link_to(name, link)
    content_tag("li", link_to(name, link))
  end
  
  def link_to_homepage(text)
    link_to(text, homepage_path)
  end
  
  def navigation_link_to(a,b)
  end
  
  def word_count(string)
    pluralize(words(string), "word")
  end
  
  def words(string)
    return string.split(/\s+/).size
  end
  
  def pluralize_verb_noun(count,noun, verb = "is")
    return pluralize_verb(count, verb) + " " + pluralize(count, noun) 
  end
  
  def pluralize_noun_verb(count, noun, verb = "is")
    
    return pluralize(count, noun) + " " + pluralize_verb(count, verb)
  end

  def pluralize_verb(count, singular, plural = nil)
    verbs = { 'has' => 'have', 'was' => 'were', 'is' => 'are', 'wants' => 'want' }
    if count == 1
      singular
    elsif plural
      plural
    elsif verbs[singular]
      verbs[singular]
    else
      singular
    end
  end
  
  def navigation_link_to(name, options = {}, html_options = {})      
    if current_page?(options)
      content_tag("span", name)
    else
      link_to name, options, html_options
    end
  end
  
  def number_in_words(number)
    numbers = {1 => "one", 2 => "two", 3 => "three", 4 => "four", 5 => "five", 6 => "six", 7 => "seven",
      8 => "eight", 9 => "nine"}
    if numbers[number]
      numbers[number]
    else
      return number.to_s
    end
  end
  
  def number_of_times_in_words(number)
    if number == 1
      return "once"
    elsif number == 2
      return "twice"
    else
       number_in_words(number) + " times"
    end
  end
  
  def x(text)
    xhtml_escape(text)
  end
  
  def xhtml_escape(text)
    html_escape(text)
  end
  
end
