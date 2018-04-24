class DeleteColumnRatings < ActiveRecord::Migration[5.1]
  def change
    remove_column :ratings, :votable_id
    remove_column :ratings, :votable_type
  end
end
