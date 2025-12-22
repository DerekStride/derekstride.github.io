#!/usr/bin/env ruby
# Generate flashcards from napkin-math-latency.csv

require 'csv'

filename = ARGV[0]
rows = CSV.read(filename, headers: true)

# Output TOML frontmatter
puts '---'
puts 'name = "Napkin Math: Latency"'
puts 'author = "Simon Eskildsen"'
puts 'source_url = "https://github.com/sirupsen/napkin-math"'
puts '---'
puts

first = true

rows.each do |row|
  operation = row['operation']
  latency = row['latency']
  throughput = row['throughput']

  next if operation.nil? || operation.empty?

  unless first
    puts
    puts '---'
    puts
  end
  first = false

  has_latency = latency && !latency.empty? && latency != 'N/A'
  has_throughput = throughput && !throughput.empty? && throughput != 'N/A'

  puts 'C:'
  puts "Operation: #{operation}"
  puts
  if has_latency
    puts "Latency: [#{latency}]"
  elsif has_throughput
    puts "Throughput: [#{throughput}]"
  end
end
