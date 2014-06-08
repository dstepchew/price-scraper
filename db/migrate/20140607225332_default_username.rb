class DefaultUsername < ActiveRecord::Migration
  def change
    change_column_default(:users, :name, '')
    User.all.each do |usr|
      usr.update_attribute(:name, "") if usr.name.nil?
    end
  end
end
