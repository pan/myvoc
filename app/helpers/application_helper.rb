module ApplicationHelper
  # name and its url mapper used by footer
  def powered_by
    teches = [ 
      { name: "Ruby on Rails", url: "http://rubyonrails.org"},
      { name: "MongoDB", url: "http://www.mongodb.org"},
      { name: "gem: camdict", url: "http://rubygems.org/gems/camdict"}
    ]
    footer_html = teches.map do |tech|
      content_tag 'a', tech[:name], href: tech[:url]
    end
    (footer_html.join " + ").html_safe
  end

  # if admin is off, return css class hide, otherwise return nothing
  def hide_admin
    admin? ? '' : 'hide'
  end

  # return true if admin switch is turned on 
  def admin?
    session[:admin] ? true : false
  end

  # if admin is on, return css class on, otherwise return off
  def admin_stat
    admin? ? 'on' : 'off'
  end

end
