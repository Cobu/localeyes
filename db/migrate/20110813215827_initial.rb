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
      t.belongs_to :user
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
  end
end
