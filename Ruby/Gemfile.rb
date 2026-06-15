require 'selenium-webdriver'
require 'nokogiri'
require 'csv'

# próba oszukania DataDome
options = Selenium::WebDriver::Firefox::Options.new
options.add_argument('--width=1366')
options.add_argument('--height=768')
driver = Selenium::WebDriver.for :firefox, options: options

url = 'https://allegro.pl/kategoria/kolekcje'

# nieudana próba robienia tego bez selenium; powstrzymana przez DataDome
=begin
headers = {
    "User-Agent" => "Mozilla/5.0 ...",
    "Accept-Language" => "pl,en-US;q=0.9,en;q=0.8",
    "accept" => "text/html,application/xhtml+xml"
}
=end
MAX_RETRIES = 3
file_name = "products.csv"
CSV.open("#{file_name}", 'w', col_sep: ';', force_quotes: true) do |csv|
    csv << ['Title', 'Price']
    (1..5).each do |page|
        retries = 0
        begin
            driver.get("#{url}?p=#{page}")
            sleep(rand(3.0..7.0))
            html = driver.page_source
            doc = Nokogiri::HTML(html)
            doc.css('article').each do |product|
                title = product.css('h2 a').text.strip
                price = product.css('[aria-label*="aktualna cena"]').attr('aria-label')&.value
                price = price&.gsub('aktualna cena', '')&.strip

                next if title.empty? || price.nil? || price.empty?
                csv << [title, price]
                puts "#{title} - #{price}"
            end
        rescue StandardError => e
            retries += 1
            puts "Err: #{e.message}, attempt: #{retries}/#{MAX_RETRIES}"
            retry if retries < MAX_RETRIES
            puts "Page #{page} skipped"
        end
    end
end

driver.quit
puts "Datad save into #{file_name}"