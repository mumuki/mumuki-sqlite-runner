require 'rspec'
require 'simplecov'
require 'dotenv/load'
require_relative './data/exercise_loader'

SimpleCov.start

require_relative '../lib/sqlite_runner'
