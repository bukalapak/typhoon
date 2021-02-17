# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

MasterConfiguration.create(
  master_server_host: "jmeter-master",
  master_server_username: "username",
  master_server_password: "userpassword",
  master_server_port: 22,
  master_server_jmeter_run_command: "/jmeter/apache-jmeter-5.1.1/bin/jmeter",
  influxdb_host: "influxdb",
  influxdb_port: 8086,
)

1.upto 2 do |i|
  SlaveServer.create(
    host: "jmeter-slave-#{i}",
    username: "username",
    password: "userpassword",
    port: 22,
    slave_type: "stress-test"
  )
end

SlaveServer.create(
  host: "jmeter-slave-load-test",
  username: "username",
  password: "userpassword",
  port: 22,
  slave_type: "load-test"
)
