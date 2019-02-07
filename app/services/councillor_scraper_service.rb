class CouncillorScraperService
  def self.dcc_host
    'https://www.dublincity.ie/councilmeetings/'
  end

  def self.scrape_portraits_from_dcc!(force = false)
    Councillor.where.not(dcc_id: nil).each do |councillor|
      next unless force or councillor.portrait.present?
      scrape_portrait_from_dcc!(councillor)
    end
  end

  def self.scrape_portrait_from_dcc!(councillor)
    url_base = dcc_host + "mgUserInfo.aspx?UID="
    page = HTTParty.get(url_base + councillor.dcc_id.to_s)
    ng_page = Nokogiri::HTML(page)

    image_url = ng_page.css('.mgBigPhoto img')[0]['src']
    img_base = 'https://www.dublincity.ie/councilmeetings/'
    councillor.remote_portrait_url = img_base + image_url
    councillor.save!
  end
end
