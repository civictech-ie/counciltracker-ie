class AddAgendaItemToMotion < ActiveRecord::Migration[5.1]
  def change
    add_column :motions, :agenda_item, :text
  end
end
