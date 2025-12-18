#!/usr/bin/env ruby
# Generate flashcards from napkin-math-latency.csv

require 'csv'

filename = ARGV[0]
rows = CSV.read(filename, headers: true)

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
