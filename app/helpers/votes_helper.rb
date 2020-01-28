module VotesHelper
  def vote_options_for_attendance(attendance)
    case attendance.status
    when "absent"
      ["absent"]
    when "exception"
      ["exception"]
    else
      [nil, "for", "against", "abstain", "absent", "exception", "not_voted"]
    end
  end
end
