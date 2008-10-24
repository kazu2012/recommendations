# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def microid(email, url)
    hash1 = Digest::SHA1.hexdigest("mailto:" + email)
    hash2 = Digest::SHA1.hexdigest(url)
    return "mailto+url:sha1:" + Digest::SHA1.hexdigest(hash1 + hash2)
  end
  
  def tag_link(tagging, rel_link = true)
    if rel_link
      link_to(tagging.tag_text, tag_path(tagging.tag.name), {:rel => "tag"})
    else
      link_to(tagging.tag_text, tag_path(tagging.tag.name))
    end
  end
  
  def user_link(user)
    link_to(user.username, user_path(user.username))
  end

  def cancel_link_to(path, text = "Cancel") 
    link_to(text, path, {:class => "cancel"})
  end

  def title(text, sub_title = nil)
    if sub_title
      content_tag(:div, content_tag(:h1, text) + content_tag(:p, sub_title), :class => :title)
    else
      content_tag("h1", text)
    end
  end

  def resource_title(entity, resource_path = nil)
    
    if resource_path
      text = link_to_unless_current(x(entity.name), resource_path)
    else 
      text = entity.name
    end
    
    title(text)
  end
  
  def editable_resource_title(entity, resource_path = nil, editable_path = nil)
    editable_text(content_tag("h1",x(entity.name)), "Rename", editable_path, resource_path)
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
    usertext(text)
  end
  
  def mark_lists(text)  
    text.gsub(/\r\n/, "\n").
    gsub(/(\n\n)((^\*\s.*$\n)+)\n/) do 
      text = "\n\n<ul>\n" + $2.gsub(/\*\s(.*)$/, '<li>\1</li>') + "</ul>\n\n"
    end
  end
  
  
  def mark_code(text)
    h(text).
    gsub(/(^&lt;.*$|&lt;.*&gt;)/) do 
      text = "<code>" + ($1) + "</code>"
    end
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
    content_tag("li", navigation_link_to(name, link))
  end
  
  def link_to_homepage(text)
    link_to(text, homepage_path)
  end
  
  def word_count(string)
    pluralize(number_of_words(string), "word")
  end
  
  def number_of_words(string)
    return words(string).size
  end
  
  def words(string)
    string = replace_typography(string).downcase.
      gsub(/[\"\',:.‘’]/, '').  #remove punctuation marks
      gsub(/(\s+)[^a-z]+(\s+)/, '\1\2').  #remove strings with no word characters
      gsub(/(^<.*$|<[^>]*>)/, '')   #remove markup
    
    return string.to_s.split(/\s+/)
  end  
  
  def replace_typography(string)
    string.
    gsub(/\'(\d\ds)/, '’\1').             # replacing '30s with ’30s
    gsub(/(\d+)"(\s)/, '\1″\2').          # replacing " with double prime
    gsub(/(\d+)'(\s)/, '\1′\2').          # replacing " with double prime
    gsub(/([^\s]+)\'(\s)/, '\1’\2').      # replacing ' with ’ (right single quote)
    gsub(/(\s)\'([^\s])/, '\1‘\2').       # replacing ' with ‘ (left single quote)
    gsub(/([^\s]+)\"/, '\1”').            # replacing " with ” (right double quote)
    gsub(/\"([a-zA-Z])/, '“\1').             # replacing " with “ (left double quote)
    gsub(/([^\s])\'([^\s])/, '\1’\2').    # replacing ' with ’ (apostrophe)
#   gsub(/(\s)\"(\s)/, '\1&#12291;\2').   # replacing " with 〃 (ditto mark)
    gsub(/(\d+)x(\d+)/, '\1×\2').         # replacing x with multiplication char
    gsub(/([a-zA-Z])-([a-zA-Z])/, '\1‐\2'). # replacing - with hyphen char
    gsub(/([\d])-([\d])/, '\1–\2').       # replacing - with en-dash
    gsub(/([^\.])\.\.\.([^\.])/, '\1…\2').# replacing ... with elipsis
    to_s
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
  
  def meta_tag(name, content)
    return tag("meta", :name => name, :content => content)
  end
  
  def x(text)
    xhtml_escape(text)
  end
  
  def xhtml_escape(text)
    html_escape(text)
  end
  
  # HTML4 version of tag helper
  def tag(name, options = nil, open = false, escape = true)
    return "<#{name}#{tag_options(options, escape) if options}#{open ? ">" : " ></#{name}>"}"
  end
  
  def auto_link(text)
    auto_link_urls(text)
  end
  
  def auto_link_urls(text, href_options = {})
    extra_options = tag_options(href_options.stringify_keys) || ""

    auto_link_re = %r{
     (                          # leading text
       <\w+.*?>|                # leading HTML tag, or
       [^=!:'"/]|               # leading punctuation, or 
       ^                        # beginning of line
     )
     (https?://)              # protocol spec

     (
       [-\w]+                   # subdomain or domain
       (?:\.[-\w]+)*            # remaining subdomains or domain
       (?::\d+)?                # port
       (?:/(?:(?:[~\w\+@%-]|(?:[,.;:][^\s$]))+)?)* # path
       (?:\?[\w\+@%&=.;-]+)?     # query string
       (?:\#[\w\-\/]*)?           # trailing anchor
     )(([[:punct:]]|\s|<|$))       # trailing text
    }x
    
    text.gsub(auto_link_re) do
      all, a, b, c, d = $&, $1, $2, $3, $5
      
      text = a + "<a href=\"" + b + c + "\">" + truncate_in_middle(c, 50) + "</a>" + $5
    end
  end
  
  def truncate_in_middle(text, length = 30, truncate_string = "...")
    if text
      l = ((length - truncate_string.chars.length) / 2).to_int
      chars = text.chars
      (chars.length > length ? chars[0...l] + truncate_string + chars[chars.length-l...chars.length] : text).to_s
    end
  end

  
end
