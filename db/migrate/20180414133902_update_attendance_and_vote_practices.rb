class UpdateAttendanceAndVotePractices < ActiveRecord::Migration[5.1]
  def change
    # TODO: run too long for heroku :(
    Meeting.all.each(&:save)
    Motion.all.each(&:save)
    Amendment.all.each(&:save)
  end
end
