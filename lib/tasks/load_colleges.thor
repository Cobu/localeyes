class Colleges < Thor

  desc 'load [full path to zip_code file]', "Load geonames city, state, zip, lat. longs into mysql"
  def load(colleges_file=nil)
    require './config/environment'
    raise "Can't find that colleges file '#{colleges_file}'" unless File.exist? colleges_file

    College.connection.execute "TRUNCATE `colleges`"
    st = College.connection.raw_connection.prepare "INSERT IGNORE INTO `colleges` (`name`, `address`, `city`, `state_short`, `zip_code`) VALUES (?, ?, ?, ?, ?)"
    File.readlines(colleges_file).each_with_index do |line|
      data = line.split("|")
      st.execute(*data)
    end
    st.close
  end
end