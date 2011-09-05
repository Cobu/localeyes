#!/usr/bin/ruby
require 'csv'
require 'pp'

f = File.open("zips.csv", 'w+')
a = []
File.readlines("/Users/modivo/Downloads/US/US.txt").each_with_index do |line,index|
  data = line.force_encoding("UTF-8").split("\t")
  a << [data[1],data[2],data[3],data[4], data[9], data[10]].join('|') if data[4]=="NY"
  #begin
  #  zip = line['Institution_Zip'].gsub('"','').sub(/-\d+/,'') rescue ''
  #  if line['Institution_State'] == 'NY'
  #    a << [line['Institution_ID'], line['Institution_Name'], line['Institution_Address'], line['Institution_City'], line['Institution_State'], zip].join('|')
  #  end
    #f << [line['Institution_ID'], line['Institution_Name'], line['Institution_Address'], line['Institution_City'], line['Institution_State'], line['Institution_Zip']]
  #rescue Exception =>e
  #  p e
  #  p line
  #end
end
#pp a
pp a.size
f << a.join("\n")