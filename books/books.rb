#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'uri'

output_file = File.open("#{Dir.home}/Dropbox/documents/txt/books/books.csv", "w")
output_file.puts ['author', 'title', 'num_pages', 'num_ratings', 'rating'].join(', ')

File.open("#{Dir.home}/Dropbox/documents/txt/books/books.txt", "r") do |file|
  file.each_line do |line|
    search_term = "#{line.strip.split(/, /)[1]} by #{line.strip.split(/, /)[0]}"
    break if line.strip == "DONE" || line.strip.empty?

    puts search_term

    url = "https://www.goodreads.com/search?utf8=%E2%9C%93&query=#{search_term}"
    escaped_url = URI.escape(url)

    # get first result with an image
    results_page = Nokogiri::HTML(open(escaped_url))
    list_item_index = 0
    list_item = nil
    loop do
      list_item = results_page.css('table.tableList tr')[list_item_index]
      break if list_item.nil?

      list_item_image_url = list_item.css('td')[0].css('img').attr('src').to_s
      list_item_num_ratings = list_item.css('td')[1].css('span.minirating').text.match(/— (.+) rating.?/)[1].tr(',', '').to_i

      list_item_index += 1
      break if !list_item_image_url.include?('nophoto') # && list_item_num_ratings >= 200
    end

    # get book details
    if !list_item.nil?
      list_item_url = "https://www.goodreads.com#{list_item.css('td')[0].css('a')[0]['href']}"

      book_page = Nokogiri::HTML(open(list_item_url))
      author = book_page.css('a.authorName')[0].css('span').text.strip
      title = book_page.css('h1.bookTitle').text.strip.gsub(/\s\s+/, ' ').tr(',', '')
      num_pages = book_page.css('span[itemprop="numberOfPages"]').text.match(/(\d+) pages/)[1].tr(',', '') if book_page.css('span[itemprop="numberOfPages"]').text.match(/(\d+) pages/)
      num_ratings = book_page.at('meta[itemprop="ratingCount"]')['content']
      rating = book_page.css('span[itemprop="ratingValue"]').text
      # puts "#{author} #{title} #{num_pages} #{num_ratings} #{rating}"

      output_file.puts [author, title, num_pages, num_ratings, rating].join(', ')
    end
  end
end
