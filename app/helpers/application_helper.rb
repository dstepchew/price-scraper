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

end
