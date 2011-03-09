# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110309015439) do

  create_table "expenses", :force => true do |t|
    t.integer  "from_user_id",         :null => false
    t.integer  "to_user_id",           :null => false
    t.float    "amount",               :null => false
    t.string   "note"
    t.integer  "type_id",              :null => false
    t.integer  "venmo_transaction_id"
    t.string   "pay_or_charge"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
