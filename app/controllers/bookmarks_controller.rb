class BookmarksController < ApplicationController
  require 'rubygems'
  require 'readability'
  require 'open-uri'

  def index
    @bookmarks = Bookmark.all.reverse
  end

  def new
    uri = params['bookmark']['uri']
    bookmark = Bookmark.create(uri: uri, title: 'Processing title...')
    CrawlUriJob.perform_later crawl_uri(uri, bookmark)
    redirect_to controller: 'bookmarks', action: 'index'
  end

  def delete
    Bookmark.delete(params[:id])
    redirect_to controller: 'bookmarks', action: 'index'
  end

  private

  def crawl_uri(uri, bookmark)
    source = open(uri)
    content = Readability::Document.new(source.read).content
    page = Nokogiri::HTML(source)

    bookmark.title = page.css('title')[0].text
    bookmark.excerpt = content #page.css('body').text[0..500]
    bookmark.save
  end

end
