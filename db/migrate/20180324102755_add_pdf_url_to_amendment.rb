class AddPdfUrlToAmendment < ActiveRecord::Migration[5.1]
  def change
    add_column :amendments, :pdf_url, :text
  end
end
