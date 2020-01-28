require "httparty"
require "nokogiri"

MIN_YEAR = 2014

class MeetingScraperService
  def self.dcc_host
    "https://www.dublincity.ie/councilmeetings/"
  end

  def self.scrape_from_dcc!
    [:monthly, :annual, :special, :budget, :finance].each do |committee|
      scrape_meetings_for_committee!(committee)
    end
  end

  def self.scrape_meetings_for_committee!(committee)
    committee_id = code_for_committee(committee)
    url_base = dcc_host + "ieListMeetings.aspx?XXR=0&CId=#{committee_id}&Year="
    year = Date.current.year

    while year >= MIN_YEAR
      page = HTTParty.get(url_base + year.to_s)
      ng_page = Nokogiri::HTML(page)

      ng_page.css(".mgNonBulletTableList .mgMeetingTableLnk").each do |meeting_link|
        dcc_id = meeting_link["href"].scan(/&(MeetingId|MId)=(\d+)&/).first.last
        create_meeting_from_dcc_id!(dcc_id, committee)
      end

      year -= 1
    end
  end

  def self.get_url_for_dcc_id(dcc_id)
    url_base = dcc_host + "mgMeetingAttendance.aspx?ID=" + dcc_id
  end

  def self.create_meeting_from_dcc_id!(dcc_id, committee)
    raise "DCC ID required." unless dcc_id.present?
    return false if Meeting.where(dcc_id: dcc_id).any? # it's already been scraped

    page = HTTParty.get(get_url_for_dcc_id(dcc_id))
    ng_page = Nokogiri::HTML(page)

    occurred_on = normalize_date(ng_page.css("#modgov h2.mgSubTitleTxt")[0].text)

    return false if occurred_on >= Date.current

    raise "No date found" unless occurred_on.present?

    council_session = CouncilSession.current_on(occurred_on).take

    councillor_selector = '[summary="Table of meeting attendance"] tbody tr'
    attendance_html = ng_page.css(councillor_selector)

    params = {
      dcc_id: dcc_id,
      occurred_on: occurred_on,
      meeting_type: committee.to_s,
    }

    @meeting = Meeting.new(params)
    @meeting.save!

    @meeting.attendances_attributes = attendances_from_html(attendance_html, @meeting)
    @meeting.save!
  end

  private

  def self.attendances_from_html(rows, meeting)
    raw_attendance = rows.map { |row|
      next unless row.css("td:first-child a").any?
      next if row.css("td")[1].text.downcase.strip == "officer"

      col_id = row.css("td")[0]
      col_status = row.css("td")[2]

      councillor_dcc_id = col_id.css("a")[0]["href"].gsub("mgUserInfo.aspx?UID=", "").to_i

      [councillor_dcc_id, normalize_attendance_status(col_status.text)]
    }.compact.to_h

    meeting.attendances.map { |attendance|
      councillor = attendance.councillor

      attendance_status = if attendance.status != "exception"
        attendance.status
      elsif raw_attendance.key?(councillor.dcc_id.to_i)
        raw_attendance[councillor.dcc_id.to_i]
      else
        "exception"
      end

      {
        id: attendance.id,
        councillor_id: councillor.id,
        status: attendance_status,
      }
    }.compact
  end

  def self.normalize_date(date_string)
    date_string = date_string.split(",")[0..1]
      .join(",").gsub("6.15 pm", "")
      .delete(",").strip
    Date.parse(date_string)
  end

  def self.normalize_attendance_status(attendance_status)
    case attendance_status.downcase.parameterize
    when "present", "in-attendance" then "present"
    when "absent" then "absent"
    when "expected" then "expected"
    else "exception"
    end
  end

  def self.code_for_committee(committee)
    case committee.to_sym
    when :monthly then 142
    when :annual then 227
    when :special then 225
    when :budget then 226
    when :finance then 151
    end
  end
end
