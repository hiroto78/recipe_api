class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors, id: :integer, unsigned: true do |t|
      t.string :name,            null: false,
                                 index: true,
                                 comment: "author's name"

      t.timestamps
    end
  end
end
