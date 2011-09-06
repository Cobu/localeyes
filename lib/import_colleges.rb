#!/usr/bin/ruby
require 'csv'
require 'pp'

f = File.open("colleges.csv", 'w+')
i = 0
a = []
CSV.foreach("/Users/modivo/Downloads/Accreditation_2011_08/Accreditation_2011_08.csv", :headers=>true) do |line|
  #begin
    zip = line['Institution_Zip'].gsub('"','').sub(/-\d+/,'') rescue ''
    if line['Institution_State'] == 'NY'
      a << [line['Institution_Name'], line['Institution_Address'], line['Institution_City'], line['Institution_State'], zip].join('|')
    end
    #f << [line['Institution_ID'], line['Institution_Name'], line['Institution_Address'], line['Institution_City'], line['Institution_State'], line['Institution_Zip']]
  #rescue Exception =>e
  #  p e
  #  p line
  #end
end
#pp a
#pp a.uniq.size
a.uniq!
f << a.join("\n")