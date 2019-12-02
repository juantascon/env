#! /usr/bin/env ruby
# -*- coding: utf-8 -*-

require "fileutils.rb"

def usage
  "Usage: #{$0} [-r] <dir>|<file>\n"
end

def rename(filename)
  base = File.basename(filename)
  dir = File.dirname(filename)

  base_dest = base.clone.instance_eval do
    downcase!
    gsub!("ñ","nh"); gsub!("Ñ","nh"); gsub!("&","_and_")
    gsub!(" ","_"); gsub!(",","_");
    gsub!("(","_"); gsub!(")","_"); gsub!("[","_"); gsub!("]","_")
    gsub!("'","")
    gsub!("_-_","-"); gsub!(".-","-"); gsub!("-.","."); gsub!("._","_"); gsub!("_.",".");
    gsub!("-_","-"); gsub!("_-","-"); gsub!("-_","-")
    gsub!("__","_")
    self
  end
  
  dest = "#{dir}/#{base_dest}"
  
  FileUtils.mv(filename, dest, :verbose => true) if base_dest != base
end

def recursive_rename(dirname)
  if File.directory?(dirname)
    Dir.foreach(dirname) do |x|
      next if x =~ /^\.{1,2}$/ # skip . and ..
      recursive_rename("#{dirname}/#{x}")
    end
  end
  rename(dirname)
end

files = Array.new
action = method(:rename)

ARGV.each do |arg|
  case arg
  when "-r"
    action = method(:recursive_rename)
  else
    files.push(arg) if File.file?(arg) or File.directory?(arg)
  end
end

if files.size <= 0
  printf "No files to rename\n"
  printf usage
end

files.each do |f|
  action.call(f)
end
