#!/usr/bin/env ruby
# Generate flashcards from napkin-math-cost.csv

require 'csv'

filename = ARGV[0]
rows = CSV.read(filename, headers: true)

# Output TOML frontmatter
puts '---'
puts 'name = "Napkin Math: Cost"'
puts 'author = "Simon Eskildsen"'
puts 'source_url = "https://github.com/sirupsen/napkin-math"'
puts '---'
puts

first = true

cost_columns = [
  '$/month',
  '1y commit $/month',
  'Spot $/month',
]

rows.each do |row|
  what = row['What']
  amount = row['Amount']

  next if what.nil? || what.empty?

  cost_columns.each do |col|
    cost = row[col]
    next if cost.nil? || cost.empty?

    unless first
      puts
      puts '---'
      puts
    end
    first = false

    puts 'C:'
    puts "Resource: #{what} (#{amount})"
    puts
    puts "#{col}: [#{cost}]"
  end
end
