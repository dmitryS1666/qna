class ChangeFieldsComment < ActiveRecord::Migration[5.1]
  def change
    rename_column :comments, :commentable_id, :commented_id
    rename_column :comments, :commentable_type, :commented_type
  end
end
