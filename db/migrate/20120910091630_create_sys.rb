class CreateSys < ActiveRecord::Migration
  def change
    create_table :sys do |t|
      t.integer :ip_id
      t.string :server
      t.integer :port
      t.boolean :status
      t.timestamps
    end
  end
end
