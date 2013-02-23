class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.string :content, null: false
      t.references :language, null: false
      t.string :template, null: false

      t.timestamps
    end
    add_index :sentences, :language_id
    add_index :sentences, :template
    add_index :sentences, [:content, :language_id, :template], unique: true
  end
end
