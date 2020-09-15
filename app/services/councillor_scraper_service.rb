class CouncillorScraperService
  def self.dcc_host
    "https://councilmeetings.dublincity.ie"
  end

  def self.scrape_portraits_from_dcc!
    figure_out_councillor_dcc_ids!

    Councillor.where.not(dcc_id: nil).each do |councillor|
      scrape_portrait_from_dcc!(councillor)
      sleep(0.5)
    end
  end

  def self.scrape_portrait_from_dcc!(councillor)
    url_base = dcc_host + "mgUserInfo.aspx?UID="
    page = HTTParty.get(url_base + councillor.dcc_id.to_s)
    ng_page = Nokogiri::HTML(page)

    image_url = ng_page.css(".mgBigPhoto img")[0]["src"]
    councillor.remote_portrait_url = dcc_host + image_url
    councillor.save!
  end

  def self.figure_out_councillor_dcc_ids!
    page = HTTParty.get(dcc_host + "mgMemberIndex.aspx")
    ng_page = Nokogiri::HTML(page)

    ng_page.css(".mgThumbsList ul > li").each do |li|
      anchor = li.css("a").first
      area_slug = li.css("p").first.try(:text).downcase.strip.parameterize
      next unless anchor.text.present? && area_slug.present?
      councillor_slug = anchor.text.downcase.strip.parameterize.gsub("councillor-", "").gsub("deputy-", "").gsub("lord-mayor-", "").gsub("mc-auliffe", "mcauliffe") # lol @ this
      councillor = Councillor.find_by!(slug: councillor_slug)

      if Seat.where(local_electoral_area: LocalElectoralArea.find_by!(slug: area_slug), councillor: councillor).empty?
        raise "possible false positive"
      end

      councillor = Councillor.find_by!(slug: councillor_slug)
      councillor.update!(dcc_id: li.css("a").first.attribute("href").value.downcase.gsub("mguserinfo.aspx?uid=", "").to_i)
    end
  end
end
