module ApplicationHelper

  def resource_statuses
    [ ["Active", "Active"], ["Inactive", "Inactive"] ]
  end

  def user_roles
    [ ["None",""], ["ADMIN", "ADMIN"] ]
  end

  def user_statuses
  	[ ["Private", "Private"], ["Public", "Public"] ]
  end	

  def user_link_text user
    if user.name.nil? || user.name.strip == ""
      user.email
    else
      user.name
    end
  end
end
