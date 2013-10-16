class FbController < ApplicationController
  def users
    @me = FbGraph::User.me(current_user.oauth_token).fetch
    @users = @me.friends.sort_by { |fb_frnd| fb_frnd.raw_attributes['name']}
  end

  def albums
    @user = FbGraph::User.new(params[:user_id], :access_token => current_user.oauth_token).fetch
    @albums = @user.albums
  end

  def photos
    @album = FbGraph::Album.new(params[:album_id], :access_token => current_user.oauth_token).fetch
    @photos = @album.photos
    @user = @album.from
  end
end
