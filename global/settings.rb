# encoding: utf-8

require 'fileutils'

# Support languages
LANGS = ["zh", "en", "ja"]

# Dump file storage path
DUMP_FILE_DIR = "/Users/ultragtx/DevProjects/Ruby/WikipediaEntityAnalyser2/data/dump_file"

# Sqlite database file storage path
DATABASE_DIR = "/Users/ultragtx/DevProjects/Ruby/WikipediaEntityAnalyser2/data/database"

FileUtils.mkdir_p DUMP_FILE_DIR
FileUtils.mkdir_p DATABASE_DIR