class Initial < ActiveRecord::Migration
  def change
    create_table "users", :force => true do |t|
      t.string :type
      t.string :email, :null => false
      t.string :password_digest, :null => false
      t.string :first_name
      t.string :last_name
      t.string :phone
    end

    create_table "businesses", :force => true do |t|
      t.belongs_to :user, :null => false
      t.string :name, :null=>false
      t.integer :service_type, :null=>false
      t.string :description
      t.string :time_zone, :default => "Eastern Time (US & Canada)"
      t.string :address, :null=>false
      t.string :address2
      t.string :city, :null=>false
      t.string :state, :null=>false
      t.string :zip_code, :null=>false
      t.string :phone, :null=>false
      t.text :hours
      t.string :url
      t.binary :image
      t.float "lat", :null => false
      t.float "lng", :null => false
      t.boolean :active
    end

    create_table "events", :force => true do |t|
      t.belongs_to :business, :null=>false
      t.integer :event_type, :default=> Event::EVENT
      t.string :title, :null=>false
      t.string :description
      t.text :schedule
      t.datetime :start_time, :null=>false
      t.datetime :end_time, :null=>false
      t.timestamps
    end

    create_table "colleges", :force => true do |t|
      t.string "name", :null => false
      t.string "address", :null => false
      t.string "city", :null => false
      t.string "state_short", :null => false
      t.string "zip_code", :null => false
      t.float "lat", :null => false
      t.float "lng", :null => false
    end

    create_table "zip_codes", :force => true do |t|
      t.string "city", :null => false
      t.string "state", :null => false
      t.string "state_short", :null => false, :limit=>2
      t.string "zip_code", :null => false
      t.float "lat", :null => false
      t.float "lng", :null => false
    end

    add_index "zip_codes", ["zip_code"], :unique => true
  end
end
