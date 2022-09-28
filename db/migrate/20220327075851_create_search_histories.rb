class CreateSearchHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :search_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :query
      t.json :results
      t.string :last_pagination
      t.timestamps
    end
  end
end