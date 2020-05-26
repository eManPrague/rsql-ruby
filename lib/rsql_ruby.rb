require 'rsql_ruby/parser'

# Main module
module RsqlRuby
  VERSION = "1.0.0"

  # Parse string to structures.
  def self.parse(str)
    parser = RsqlRuby::Parser.new
    parser.parse(str)
  end
end
