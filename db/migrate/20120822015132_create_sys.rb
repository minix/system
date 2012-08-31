class CreateSys < ActiveRecord::Migration
  def change
    create_table :sys do |t|
			t.integer :ip_addr, limit: 8, null: false
			t.integer :port, null:false , default: 0
			t.string 	:service
			t.boolean	:status, default: 0, null: false

      t.timestamps
    end
  end
end
