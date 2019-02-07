class AddPortraitFileToCouncillor < ActiveRecord::Migration[5.1]
  def change
    add_column :councillors, :portrait_file, :text
  end
end
