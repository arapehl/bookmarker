class BookmarksController < ApplicationController
  before_action :authenticate_account!

  def index
    @bookmarks = current_account.bookmarks.all.order('created_at DESC')
  end

  def create
    uri = params['bookmark']['uri']
    bookmark = current_account.bookmarks.create(uri: uri, title: 'Processing title...')
    CrawlUriJob.perform_later(uri, bookmark)
    redirect_to bookmarks_path
  end

  def destroy
    Bookmark.delete(params[:id])
    redirect_to bookmarks_path
  end
end
