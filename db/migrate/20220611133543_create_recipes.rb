class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes, id: :integer, unsigned: true do |t|
      t.string :title,            null: false,
                                  comment: "recipe's title"

      t.references :author,       type: :integer,
                                  null: false,
                                  unsigned: true,
                                  index: true,
                                  foreign_key: true,
                                  comment: 'author.id'

      t.string :description,      default: '',
                                  comment: "recipe's description"

      t.jsonb :ingredient, null: false,
                           comment: 'ingredient json'

      t.string :process,          default: '',
                                  comment: "recipe's process"

      t.datetime :deleted_at,     default: nil,
                                  index: true,
                                  comment: 'deleted at'
      t.timestamps
    end
  end
end
