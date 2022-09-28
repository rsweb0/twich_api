class UsersController < ApplicationController
  before_action :authenticate_user!

  def history
    @versions = current_user.search_histories.last(10) #.order('created_at DESC')
  end
end
