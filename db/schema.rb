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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_28_070919) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "jmeters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "jmx_id"
    t.string "jmx_name"
    t.integer "threads"
    t.integer "ramp"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.integer "timeouts"
    t.string "testing_type"
  end

  create_table "jmxes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "load_test_reports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "load_test_id"
    t.integer "jmeter_id"
    t.string "label"
    t.integer "samples"
    t.integer "average"
    t.integer "percentile_90"
    t.integer "percentile_95"
    t.integer "percentile_99"
    t.integer "min"
    t.integer "max"
    t.integer "error_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.integer "percentile_90_previous"
    t.integer "percentile_95_previous"
    t.integer "percentile_99_previous"
    t.integer "threshold"
    t.index ["load_test_id", "jmeter_id"], name: "index_load_test_reports_on_load_test_id_and_jmeter_id"
  end

  create_table "load_tests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "jmx_id"
    t.string "jmx_name"
    t.integer "threads"
    t.integer "ramp"
    t.integer "duration"
    t.string "squad"
    t.text "note"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "timeouts"
    t.bigint "telegram_id"
    t.integer "threshold"
  end

  create_table "master_configurations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "master_server_host"
    t.string "master_server_docker_host"
    t.string "master_server_username"
    t.integer "master_server_port"
    t.string "master_server_password"
    t.string "master_server_jmeter_run_command"
    t.string "influxdb_host"
    t.integer "influxdb_port"
    t.string "telegram_credential"
    t.bigint "telegram_perf_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slave_servers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "host"
    t.string "username"
    t.integer "port"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password"
    t.string "slave_type"
    t.string "slave_status", default: "ON"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
