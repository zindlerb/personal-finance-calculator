require 'optparse'


OptionParser.new do |parser|
	parser.on("-f", "--file NAME", "File to upload") do |f|
    options[:filepath] = f

  end

	parser.on("-d", "--display", "Display finances") do ||
		FinanceRenderer.render
  end
end.parse!

class TerminalRenderer
	def self.render
	end
end

class DatabaseManager
	def self.upload_transactions(filepath)
		# file upload
		# upload history
	end
end

# Architecture:
#   - filters - renames lines from x to y or sums lines or hides certain lines
#   - renderer
#   - Persister
