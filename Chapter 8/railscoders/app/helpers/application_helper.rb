# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def yes_no(bool)    
    if bool == true
      "yes"
    else
      "no"
    end
  end
end
