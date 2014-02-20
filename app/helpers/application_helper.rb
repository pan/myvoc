module ApplicationHelper
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

end
