require 'nokogiri'
require 'open-uri'
require 'json'

Product = Struct.new(:title, :price) do
    def to_json(*options)
      to_h.to_json(*options)
    end
end

url = 'https://www.empik.com/szukaj/produkt?q=ksiazka'
doc = Nokogiri::HTML(URI.open(url))

products = []
doc.css('.search-list-item').each do |product|
    title = product.css('.ta-product-title').text.strip
    price = product.css('.ta-price-tile[content]').text.strip
    products.append(Product.new(title, price))
end

puts JSON.pretty_generate(products)