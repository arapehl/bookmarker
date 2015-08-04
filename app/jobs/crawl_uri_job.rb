class CrawlUriJob < ActiveJob::Base
  require 'rubygems'
  require 'readability'
  require 'open-uri'

  queue_as :default

  include ActionView::Helpers::SanitizeHelper

  def perform(uri, bookmark)
    source = open(uri).read
    doc = Readability::Document.new(source)
    words = strip_tags(doc.content).split(' ')
    excerpt = words[0..50].join(' ')

    bookmark.update(title: doc.title, excerpt: "#{ excerpt }...")
  end
end
