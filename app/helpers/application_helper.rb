# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # All top-level headings on pages should use this helper like so:
  # %h1=title "Some Title"
  # This sets the <title> tag appropriately in the head of the page.
  def title(text)
    @title = text
    return text
  end
  # Returns a character portrait next to the character name.
  def character(c)
    image_tag(c.portrait(16), :class=>'logo')+" "+h(c.name)
  end
  # Returns a corporation logo next to the corporation name.
  def corporation(c)
    image_tag(c.logo(16), :class=>'logo')+" "+h(c.name)
  end
  # Returns an alliance logo next to the alliance name.
  def alliance(a)
    image_tag(a.logo(16), :class=>'logo')+" "+h(a.name)
  end
end

