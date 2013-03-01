require 'fileutils'

LANGS = ["zh", "en", "ja"]

DUMP_FILE_DIR = "/Users/ultragtx/DevProjects/Ruby/WikipediaEntityAnalyser2/data/dump_file"
DATABASE_DIR = "/Users/ultragtx/DevProjects/Ruby/WikipediaEntityAnalyser2/data/database"

FileUtils.mkdir_p DUMP_FILE_DIR
FileUtils.mkdir_p DATABASE_DIR