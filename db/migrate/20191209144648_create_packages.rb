class CreatePackages < ActiveRecord::Migration[6.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :version
      t.datetime :publication_date
      t.string :title
      t.string :description

      t.timestamps
    end

    add_index :packages, [:name, :version], unique: true
  end
end
