class CreateSys < ActiveRecord::Migration
  def change
    create_table :sys do |t|
      t.string :ip_addr
      t.integer :port
      t.string :service
      t.boolean :status

      t.timestamps
    end
  end
end
