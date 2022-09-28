class User < ApplicationRecord
  has_many :search_histories

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :validatable

  def history_ids
    search_histories.pluck(:results).flatten.map{|t| t["id"]}.try(:uniq)
  end

  # return search histories for a user, for a given query
  def search_histories_by_query(query)
    search_histories.find_by(query: query)
  end

end
