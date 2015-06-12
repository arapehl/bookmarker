class BookmarksController < ApplicationController
  require 'open-uri'

  def index
    @bookmarks = Bookmark.all.reverse
  end

  def new
    uri = params['bookmark']['uri']
    bookmark = Bookmark.create uri: uri
    bookmark.title = 'Processing URL...'
    bookmark.save
    CrawlUriJob.perform_later crawl_uri(uri, bookmark)
    redirect_to controller: 'bookmarks', action: 'index'
  end

  def delete
    Bookmark.delete(params[:id])
    redirect_to controller: 'bookmarks', action: 'index'
  end

  private

  def crawl_uri(uri, bookmark)
    page = Nokogiri::HTML(open(uri))
    bookmark.title = page.css('title')[0].text
    bookmark.excerpt = page.css('body').text[0..500]
    bookmark.save
  end

end
