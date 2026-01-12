class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :group, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.text :description
      t.datetime :starts_at, null: false
      t.boolean :public, default: false, null: false

      t.timestamps
    end

    add_index :events, :starts_at
    add_index :events, :public
  end
end
