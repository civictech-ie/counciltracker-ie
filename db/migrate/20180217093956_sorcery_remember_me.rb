class SorceryRememberMe < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :remember_me_token, :text, default: nil
    add_column :users, :remember_me_token_expires_at, :datetime, default: nil

    add_index :users, :remember_me_token
  end
end
