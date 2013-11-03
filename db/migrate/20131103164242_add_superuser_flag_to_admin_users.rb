class AddSuperuserFlagToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :superuser, :boolean, null: false, default: false
  end
end
