class AddPdfUrlToMotion < ActiveRecord::Migration[5.1]
  def change
    add_column :motions, :pdf_url, :text
  end
end
