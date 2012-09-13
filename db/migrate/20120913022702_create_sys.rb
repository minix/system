class CreateSys < ActiveRecord::Migration
  def change
    create_table :sys do |t|

      t.string :server
      t.integer :port
			t.integer :ip_id
      #t.boolean :status
      t.timestamps
    end
  end
end
