class CreateIps < ActiveRecord::Migration
  def change
    create_table :ips do |t|
			t.string :ip_addr
			#t.boolean :status, default: 0

      t.timestamps
    end
  end
end
