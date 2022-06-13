class CreateRates < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings, id: :integer, unsigned: true do |t|
      t.references :recipe,       type: :integer,
                                  null: false,
                                  unsigned: true,
                                  index: true,
                                  foreign_key: true,
                                  comment: 'recipe.id'

      t.references :author,       type: :integer,
                                  null: false,
                                  unsigned: true,
                                  index: true,
                                  foreign_key: true,
                                  comment: 'author.id'

      t.integer :rate, null: false,
                       unsigned: true,
                       index: true,
                       comment: "author's rating against recipe"
      t.timestamps
    end
    add_index :ratings, %i[recipe_id author_id], unique: true
  end
end
