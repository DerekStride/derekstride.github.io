#!/usr/bin/env ruby
# Convert hashcards TOML frontmatter to Jekyll YAML frontmatter

require 'toml-rb'

filename = ARGV[0]
content = File.read(filename)

# Split frontmatter from content
if content.start_with?("---\n")
  parts = content.split("---\n", 3)
  toml_frontmatter = parts[1]
else
  toml_frontmatter = ""
end

# Parse TOML frontmatter
metadata = TomlRB.parse(toml_frontmatter)

# Output Jekyll YAML frontmatter
puts "---"
puts "layout: flashcard"
puts "title: \"#{metadata['name'] || 'Flashcards'}\""
metadata.except("name").each do |key, value|
  puts "#{key}: \"#{value}\""
end
puts "---"
