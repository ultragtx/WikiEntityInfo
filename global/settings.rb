# encoding: utf-8

require 'fileutils'

# Support languages
LANGS = ["zh", "en", "ja"]

# Dump file storage path
DUMP_FILE_DIR = "/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/data/dump_file"

# Sqlite database file storage path
DATABASE_DIR = "/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/data/database"

FileUtils.mkdir_p DUMP_FILE_DIR
FileUtils.mkdir_p DATABASE_DIR


# MySQL database

MYSQL_HOST = "127.0.0.1"
MYSQL_USER = "root"
MYSQL_PASSWD = ""
MYSQL_DATABASE_NAME = "wikientity"
