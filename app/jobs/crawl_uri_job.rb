class CrawlUriJob < ActiveJob::Base
  require 'rubygems'
  require 'readability'
  require 'open-uri'

  queue_as :default

  def perform(uri, bookmark)
    binding.pry
    source = open(uri).read
    doc = Readability::Document.new(source)

    bookmark.title = doc.title
    bookmark.excerpt = doc.content
    bookmark.save
  end
end
