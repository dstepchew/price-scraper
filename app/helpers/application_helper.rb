module ApplicationHelper

  def resource_statuses
    [ ["Active", "Active"], ["Inactive", "Inactive"] ]
  end

  def user_roles
    [ ["None",""], ["Admin", "Admin"] ]
  end
end
