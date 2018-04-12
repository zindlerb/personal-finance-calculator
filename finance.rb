#!/usr/bin/env ruby

require 'optparse'
require 'sqlite3'
require 'csv'

# SqlClient
	# helper functions around sql methods
# QueryManager
	# responsibel for getting data out of sql in a presentable format to the rest of the program
# FinancialDataIngester
	# responsible for getting the data from csv's inside of sql

class QueryManager
	attr_accessor :db

	def initialize(db)
		self.db
	end

	def self.current_month_transactions
		puts db.execute <<-SQL
			SELECT amount
			FROM raw_payee, transactions, posted_date
			WHERE posted_date > #{}
		SQL
		# all month transactions
	end
end

class FinanceDatabase
	DATABASE_NAME = "bz_simple_finance"

	attr_accessor :db

	def initialize
		self.db = SQLite3::Database.new DATABASE_NAME
	end

	def setup_database
		rows = db.execute <<-SQL
  		create table transactions (
    		refnumber text,
    		raw_payee text,
				address text,
				amount float,
				posted_date integer,
  		);
		SQL
	end

	def execute(query_str)
		db.execute query_str
	end

	def delete_database
	end

	def insert(col_name_value_pairs)
		columns = col_name_value_pairs.map(&:first)
		values = col_name_value_pairs.map(&:last)

		db.execute <<-SQL
			INSERT INTO table_name (#{columns.join(', ')})
			VALUES (#{values.join(', ')});
		SQL
	end

	def select(columns, table, where_clauses=nil)

	end
end

class FinanceDataIngester
	def self.upload_transactions(filepath, db)
		CSV.foreach(filepath) do |row|
			posted_date, reference_number, raw_payee, address, amount = row

			db.insert([
				['posted_date', convert_posted_date(posted_date).to_i],
				['refnumber', reference_number],
				['raw_payee', raw_payee],
				['address', address],
				['amount', amount.to_f]
			])
		end
	end

	private

	def self.convert_posted_date(posted_date_str)
		month, day, year = posted_date_str.split('/').map(&:to_i)
		DateTime.new(year, month, day)
	end
end


class TerminalRenderer
	def self.render()
		# Display how much I have spent this month, how much I have spent today, how much I have spent yesterday
		# Display last months expenses
			# bonus (mark what is recurring)
		#
	end

	private
	def self.table
	end
end

OptionParser.new do |parser|
	parser.on("-f", "--file NAME", "File to upload") do |filepath|
		db = FinanceDatabase.new
		FinanceDataIngester.new.upload_transactions(filepath, db)
  end

	parser.on("-i", "--initialize", "setup data base") do |f|
		FinanceDatabase.new.setup_database
  end

	parser.on("-d", "--display", "Display finances") do ||
		FinanceRenderer.render
  end
end.parse!





# Architecture:
#   - filters - renames lines from x to y or sums lines or hides certain lines
#   - renderer
#   - Persister
