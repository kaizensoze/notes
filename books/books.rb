#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'uri'

output_file = File.open("#{Dir.home}/Dropbox/documents/txt/books/books.csv", "w")
output_file.puts ['title', 'author', '# pages'].join(', ')

File.open("#{Dir.home}/Dropbox/documents/txt/books/books.txt", "r") do |file|
  file.each_line do |line|
    search_term = line.strip
    next if search_term.empty?
    break if search_term == "DONE"

    puts search_term

    url = "http://www.goodreads.com/search?utf8=%E2%9C%93&query=#{search_term}"
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
      break if !list_item_image_url.include?('nophoto') && list_item_num_ratings >= 200
    end

    # get book details
    if !list_item.nil?
      list_item_url = "http://www.goodreads.com#{list_item.css('td')[0].css('a')[0]['href']}"

      book_page = Nokogiri::HTML(open(list_item_url))
      title = book_page.css('h1.bookTitle').text.strip.gsub(/\s\s+/, ' ').tr(',', '')
      author = book_page.css('a.authorName')[0].css('span').text.strip
      num_pages = book_page.css('span[itemprop="numberOfPages"]').text.match(/(\d+) pages/)[1].tr(',', '') if book_page.css('span[itemprop="numberOfPages"]').text.match(/(\d+) pages/)

      # title, author, # pages
      output_file.puts [title, author, num_pages].join(', ')
    end
  end
end
