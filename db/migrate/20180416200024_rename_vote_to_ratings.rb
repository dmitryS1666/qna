class RenameVoteToRatings < ActiveRecord::Migration[5.1]
  def change
    rename_table :votes, :ratings
  end
end
