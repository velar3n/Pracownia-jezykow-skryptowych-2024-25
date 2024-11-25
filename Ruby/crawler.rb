require 'nokogiri'
require 'open-uri'
require 'json'
require 'sequel'

DB = Sequel.sqlite('products.db')

DB.create_table? :products do
    primary_key :id
    String :title
    String :price
    String :product_id
    Float :rating
    Integer :rating_count
    String :categories
    String :link
end

class Product < Sequel::Model(:products)
    def to_json(*options)
        to_h.to_json(*options)
    end
end

def get_page(search_query)
    url = "https://www.empik.com/szukaj/produkt?q=#{search_query}"
    puts url
    begin
        doc = Nokogiri::HTML(URI.open(url))
        return doc
    rescue OpenURI::HTTPError => e
        puts "Error fetching search results: #{e.message}"
        return nil
    end
end

def get_product_details(url)
    begin
        doc = Nokogiri::HTML(URI.open(url))

        meta_tag = doc.at_css('meta[property="product:category_tree"]')
        if meta_tag
            categories = meta_tag['content']
            categories.split('&gt;').join(', ')
        end

        script_tag = doc.at_css('script:contains("window.__APOLLO_STATE__")')
        json_data = script_tag.text.match(/window\.__APOLLO_STATE__ = (\{.*?\});/m)[1]
        data = JSON.parse(json_data)
        product_key = data.keys.find { |key| key.start_with?("Product:") }
        product_data = data[product_key]
        product_id = product_data["id"]
        rating = product_data.dig("baseInformation", "rating")
        rating_score = rating["score"]
        rating_count = rating["count"]
        return product_id, rating_score, rating_count, categories
    end
end

def search_products(doc)
    products = []
    base_url = 'https://www.empik.com'
    doc.css('.search-list-item').each do |product|
        title = product.css('.ta-product-title').text.strip
        price = product.css('.ta-price-tile[content]').text.strip
        link = base_url + product.at_css('a.seoTitle')['href'].strip
        product_id, rating_score, rating_count, categories = get_product_details(link)

        products << Product.new(
        title: title,
        price: price,
        product_id: product_id,
        rating: rating_score,
        rating_count: rating_count,
        categories: categories,
        link: link
      )
    end
    return products
end

search_query = ARGV.join().gsub(' ', "%20")
page = get_page(search_query)
if page
    products = search_products(page)
    products.each(&:save)
    puts "#{products.length} products saved to database."
else
    puts "Failed to fetch the search page."
end
