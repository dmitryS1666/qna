class AddCompositeIndexToAttachments < ActiveRecord::Migration[5.1]
  def change
    remove_index :attachments, :attachable_type
    remove_index :attachments, :attachable_id
    add_index :attachments, [:attachable_id, :attachable_type]
  end
end