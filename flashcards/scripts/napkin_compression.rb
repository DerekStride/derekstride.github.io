#!/usr/bin/env ruby
# Generate flashcards from napkin-math-compression.csv

require 'csv'

filename = ARGV[0]
rows = CSV.read(filename, headers: true)

# Output TOML frontmatter
puts '---'
puts 'name = "Napkin Math: Compression"'
puts 'author = "Simon Eskildsen"'
puts 'source_url = "https://github.com/sirupsen/napkin-math"'
puts '---'
puts

first = true

rows.each do |row|
  what = row['What']
  ratio = row['Compression Ratio']

  next if what.nil? || what.empty?

  unless first
    puts
    puts '---'
    puts
  end
  first = false

  puts 'C:'
  puts "Data type: #{what}"
  puts
  puts "Compression ratio: [#{ratio}]" if ratio && !ratio.empty?
end
