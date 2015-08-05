class BookmarksController < ApplicationController
  before_action :authenticate_account!

  respond_to :html
  respond_to :json

  def index
    @bookmarks = current_account.bookmarks.all.order('created_at DESC')
    respond_with @bookmarks do |format|
      format.json do
        render json: @bookmarks
      end
    end
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
