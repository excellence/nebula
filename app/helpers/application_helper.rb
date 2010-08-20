# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # All top-level headings on pages should use this helper like so:
  # %h1=title "Some Title"
  # This sets the <title> tag appropriately in the head of the page.
  def title(text)
    @title = text
    return text
  end
end

