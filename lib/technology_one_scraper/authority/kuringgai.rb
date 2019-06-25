require 'scraperwiki'
require 'mechanize'

module TechnologyOneScraper
  module Authority
    module Kuringgai
      def self.scrape_and_save
        period = 'L28'
        webguest = "KC_WEBGUEST"

        base_url = "https://eservices.kmc.nsw.gov.au/T1ePropertyProd"
        query = {
          "Field" => "S",
          "Period" => period,
          "r" => webguest,
          # Even though the last bit "TW" represents the period, it doesn't
          # seem to affect the search result just whether it's authenticated
          # TODO: Investigate this some more
          "f" => "P1.ETR.SEARCH.S" + "TW"
        }.to_query
        url = "#{base_url}/P1/eTrack/eTrackApplicationSearchResults.aspx?" + query

        agent = Mechanize.new
        page = agent.get(url)

        while page
          Page::Index.scrape(page, webguest) do |record|
            TechnologyOneScraper.save(record)
          end
          page = Page::Index.next(page)
        end
      end
    end
  end
end
