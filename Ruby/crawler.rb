require 'nokogiri'
require 'open-uri'
require 'json'

Product = Struct.new(:title, :price) do
    def to_json(*options)
      to_h.to_json(*options)
    end
end

def get_page(search_query)
    url = "https://www.empik.com/szukaj/produkt?q=#{search_query}"
    doc = Nokogiri::HTML(URI.open(url))
    return doc
end

def search_products(doc)
    products = []
    doc.css('.search-list-item').each do |product|
        title = product.css('.ta-product-title').text.strip
        price = product.css('.ta-price-tile[content]').text.strip
        products.append(Product.new(title, price))
    end
    return products
end

search_query = ARGV.join().gsub(' ', "%20")
page = get_page(search_query)
products = search_products(page)
puts JSON.pretty_generate(products)