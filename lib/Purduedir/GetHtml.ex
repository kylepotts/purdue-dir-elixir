defmodule Purduedir.GetHtml do
  use HTTPoison.Base
  alias Purduedir.ScrapeHtml, as: Scrapper
  def process_url(url) do
    url = URI.encode_www_form(url)
    "https://www.purdue.edu/directory?SearchString=" <> url
  end

   def process_response_body(body) do
     people = Scrapper.scrape(body)
     {status,people_json} = JSON.encode(people)
     people_json
   end
end
