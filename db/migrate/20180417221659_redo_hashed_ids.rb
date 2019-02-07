class RedoHashedIds < ActiveRecord::Migration[5.1]
  def change
    Meeting.all.each(&:refresh_hashed_id!)
    Motion.all.each(&:refresh_hashed_id!)
    Amendment.all.each(&:refresh_hashed_id!)
  end
end
