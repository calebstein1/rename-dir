#!/usr/bin/env ruby

dir = ARGV[0] ? ARGV[0] : '.'
files = []
tmp_file_name = `mktemp`.chomp
tmp_file = File.open(tmp_file_name, 'w')

Dir["#{dir}/*"].each do |path|
  file_name = path.split("/")[-1]
  files.push(file_name)
end
tmp_file.puts files
tmp_file.close

`xterm -e nvim #{tmp_file_name}`

tmp_file = File.open(tmp_file_name, 'r')
new_file_names = tmp_file.readlines.map(&:chomp)
tmp_file.close
File.delete(tmp_file_name)

raise "Number of directory items do not match!" unless files.length == new_file_names.length

rename_hash = files.zip(new_file_names).to_h
puts 'The files will be renamed:'
rename_hash.each { |key, value| puts "#{key} => #{value}" }
puts 'Confirm? (y/N)'
rename_hash.each { |key, value| File.rename("#{dir}/#{key}", "#{dir}/#{value}") } if $stdin.gets.chomp == 'y'
