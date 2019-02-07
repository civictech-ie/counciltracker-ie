namespace :councillors do
  desc 'Scrape councillors from DCC'
  task :scrape => :environment do
    CouncillorScraperService.scrape_portraits_from_dcc!
  end
end
