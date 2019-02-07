class AddAdminToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean
    add_index :users, :admin

    ['info@dublininquirer.com', 'brian@elbow.ie', 'samtranum@gmail.com'].each do |email_address|
      user = User.where(email_address: email_address).take
      if user.present?
        user.update_column(:admin, true)
      end
    end
  end
end
