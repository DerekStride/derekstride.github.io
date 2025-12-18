#!/usr/bin/env ruby
# Generate flashcards from napkin-math-compression.csv

require 'csv'

filename = ARGV[0]
rows = CSV.read(filename, headers: true)

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
