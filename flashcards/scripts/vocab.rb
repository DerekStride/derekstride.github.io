#!/usr/bin/env ruby
require 'csv'

filename = ARGV[0]
lines = File.readlines(filename)
a_key, b_key = lines.first.split(',').map(&:strip)

first = true
CSV.parse(lines.drop(1).join, col_sep: ',', quote_char: '"').each do |a, b|
  a = a.strip
  b = b.strip
  unless first
    puts
    puts '---'
    puts
  end
  first = false
  puts 'C:'
  puts "#{a_key}: [#{a}]"
  puts
  puts "#{b_key}: [#{b}]"
end
