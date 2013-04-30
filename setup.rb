# encoding: utf-8

require 'yaml'

config = YAML.load_file "config/config.yaml"

adapter = config["database"]["adapter"]
database = config["database"]["database"]

sequel_command = "sequel -m db/migration sqlite://db/#{database}.db"
puts sequel_command
system sequel_command