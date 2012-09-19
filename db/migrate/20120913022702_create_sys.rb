class CreateSys < ActiveRecord::Migration
  def change
    create_table :sys do |t|

      t.string :server
			t.string :oid, defautl: 0
      t.integer :port
			t.integer :ip_id
      t.boolean :status, default: 0
      t.timestamps
    end
  end
end
