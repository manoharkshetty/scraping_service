class CreateMaintainers < ActiveRecord::Migration[6.0]
  def change
    create_table :maintainers do |t|
      t.string :name
      t.string :email
      t.integer :package_id
      t.timestamps
    end
  end
end
