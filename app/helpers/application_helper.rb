# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title
    return @page_title || controller.action_name
  end

  def body_id
    return @body_id ? " id=\"#{@body_id}\"" : ''
  end
end
