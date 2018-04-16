class ChangeFieldsRatings < ActiveRecord::Migration[5.1]
  def change
    add_column :ratings, :vote, :integer, default: 0, null: false
    add_column :ratings, :appraised_type, :string
    add_column :ratings, :appraised_id, :bigint
    add_index :ratings, [:appraised_id, :appraised_type, :user_id]
    add_index :ratings, [:appraised_id, :appraised_type]
    remove_index :ratings, name: "index_ratings_on_votable_id_and_votable_type"
  end
end
