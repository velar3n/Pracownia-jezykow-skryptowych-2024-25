# Empik Crawler - Ruby

## Author: Natalia Kiełbasa

This Ruby script scrapes product information from the Empik website based on a given search query. It stores the results in an SQLite database.

## Features
- Scrapes product details including title, price, rating, rating count, categories, and product link.
- Uses Nokogiri for HTML parsing and Sequel for database management.
- Stores scraped data in a local SQLite database.
- Handles HTTP errors.

## Requirements
- Ruby (2.7 or higher recommended)
- The following gems:
  - `nokogiri`
  - `open-uri`
  - `json`
  - `sequel`

## Run the script
1. Save 'crawler.rb' locally
2. Run the script: 
```bash
ruby crawler.rb search_query
```